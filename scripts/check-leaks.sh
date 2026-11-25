#!/usr/bin/env bash
# 공개 전에 개인정보·비밀·기기 고유 경로가 저장소에 들어갔는지 검사한다.
#
#   scripts/check-leaks.sh             추적 대상 파일(커밋 전 포함) 검사
#   scripts/check-leaks.sh --history   커밋 히스토리의 추가 줄과 작성자/커미터 이메일도 검사
#
# 추가 금지어: local/leak-patterns.txt (한 줄에 정규식 하나, 공개 키트에서는 git 제외)
#              또는 PAK_LEAK_PATTERNS_FILE 환경변수로 지정한 파일
# 허용 목록:   .leak-allow (한 줄에 고정 문자열 하나. 이 문자열을 포함한 줄은 검사에서 제외)
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
SELF="scripts/check-leaks.sh"
HISTORY=0
[ "${1:-}" = "--history" ] && HISTORY=1

PATTERNS=(
  '/Users/[A-Za-z0-9._-]+/'
  '/home/[A-Za-z0-9._-]+/'
  '[A-Za-z]:\\Users\\'
  '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
  'gh[pousr]_[A-Za-z0-9]{30,}'
  'github_pat_[A-Za-z0-9_]{30,}'
  'sk-[A-Za-z0-9_-]{20,}'
  'xox[abprs]-[A-Za-z0-9-]{10,}'
  'AKIA[0-9A-Z]{16}'
  'AIza[0-9A-Za-z_-]{30,}'
  '-----BEGIN [A-Z ]*PRIVATE KEY-----'
  '[Bb]earer [A-Za-z0-9._-]{20,}'
)
# 이메일 패턴의 정상 예외
SAFE_EMAIL='users\.noreply\.github\.com|noreply@github\.com|@example\.(com|org)|noreply@anthropic\.com'

EXTRA="${PAK_LEAK_PATTERNS_FILE:-local/leak-patterns.txt}"
if [ -f "$EXTRA" ]; then
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in ''|'#'*) continue ;; esac
    PATTERNS+=("$line")
  done < "$EXTRA"
fi

ALLOW_FILE=".leak-allow"
filter_allow() {
  if [ -s "$ALLOW_FILE" ]; then
    grep -vF -f <(grep -v '^#' "$ALLOW_FILE" | grep -v '^$') || true
  else
    cat
  fi
}

PATTERN_FILE="$(mktemp)"
trap 'rm -f "$PATTERN_FILE"' EXIT
printf '%s\n' "${PATTERNS[@]}" > "$PATTERN_FILE"

FOUND=0

files=()
while IFS= read -r f; do
  [ "$f" = "$SELF" ] && continue
  [ -f "$f" ] && [ ! -L "$f" ] && files+=("$f")
done < <(git ls-files -co --exclude-standard)

if [ "${#files[@]}" -gt 0 ]; then
  hits="$(grep -nIE -f "$PATTERN_FILE" "${files[@]}" 2>/dev/null | grep -vE "$SAFE_EMAIL" | filter_allow)"
  if [ -n "$hits" ]; then
    echo "== 파일에서 발견 =="
    echo "$hits"
    FOUND=1
  fi
fi

if [ "$HISTORY" -eq 1 ] && git rev-parse --verify -q HEAD >/dev/null; then
  hist="$(git log --all -p --no-color -- . ":(exclude)$SELF" | grep -E '^\+[^+]' | sed 's/^+//' | grep -E -f "$PATTERN_FILE" | grep -vE "$SAFE_EMAIL" | filter_allow | sort -u)"
  if [ -n "$hist" ]; then
    echo "== 커밋 히스토리에서 발견 =="
    echo "$hist"
    FOUND=1
  fi
  emails="$(git log --all --format='%ae%n%ce' | sort -u | grep -vE "$SAFE_EMAIL" | filter_allow)"
  if [ -n "$emails" ]; then
    echo "== noreply가 아닌 작성자/커미터 이메일 =="
    echo "$emails"
    FOUND=1
  fi
fi

if [ "$FOUND" -eq 0 ]; then
  echo "유출 의심 항목 없음."
fi
exit "$FOUND"
