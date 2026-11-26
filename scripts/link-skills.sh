#!/usr/bin/env bash
# 스킬 링크를 만든다. 기존 파일·디렉터리·다른 링크는 덮어쓰지 않는다(멱등).
#
#   scripts/link-skills.sh              프로젝트: .claude/skills -> ../.agents/skills
#   scripts/link-skills.sh --global     local/skills/* 를 전역 스킬 경로에 링크
#   scripts/link-skills.sh --global --include-kit   키트 스킬(.agents/skills/*)도 전역에 링크
#   scripts/link-skills.sh --module daily-work      선택 모듈 스킬을 .agents/skills에 등록
#   --dry-run                           실제로 만들지 않고 계획만 출력
#
# 전역 경로: ~/.agents/skills (Codex, Gemini), ~/.claude/skills (Claude)
# 시험할 때는 HOME=$(mktemp -d) scripts/link-skills.sh --global 처럼 HOME을 바꿔 실행한다.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GLOBAL=0
INCLUDE_KIT=0
DRY_RUN=0
MODULE=""
EXPECT_MODULE=0
for arg in "$@"; do
  if [ "$EXPECT_MODULE" -eq 1 ]; then
    MODULE="$arg"
    EXPECT_MODULE=0
    continue
  fi
  case "$arg" in
    --module) EXPECT_MODULE=1 ;;
    --global) GLOBAL=1 ;;
    --include-kit) INCLUDE_KIT=1 ;;
    --dry-run) DRY_RUN=1 ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    *) echo "알 수 없는 옵션: $arg" >&2; exit 2 ;;
  esac
done

CONFLICTS=0

# link <target> <link_path>
link() {
  local target="$1" path="$2"
  if [ -L "$path" ]; then
    if [ "$(readlink "$path")" = "$target" ]; then
      echo "일치  $path"
    else
      echo "충돌  $path -> $(readlink "$path") (기대: $target)"
      CONFLICTS=$((CONFLICTS + 1))
    fi
    return
  fi
  if [ -e "$path" ]; then
    echo "충돌  $path (링크가 아닌 기존 항목)"
    CONFLICTS=$((CONFLICTS + 1))
    return
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "추가  $path -> $target (dry-run)"
    return
  fi
  mkdir -p "$(dirname "$path")"
  ln -s "$target" "$path"
  echo "추가  $path -> $target"
}

if [ "$EXPECT_MODULE" -eq 1 ]; then
  echo "--module 뒤에 모듈 이름이 필요합니다." >&2
  exit 2
fi

if [ -n "$MODULE" ]; then
  if [ ! -d "$ROOT/modules/$MODULE/skills" ]; then
    echo "모듈이 없습니다: modules/$MODULE/skills" >&2
    exit 2
  fi
  for d in "$ROOT/modules/$MODULE/skills"/*/; do
    [ -f "${d}SKILL.md" ] || continue
    name="$(basename "$d")"
    link "../../modules/$MODULE/skills/$name" "$ROOT/.agents/skills/$name"
  done
elif [ "$GLOBAL" -eq 0 ]; then
  link "../.agents/skills" "$ROOT/.claude/skills"
else
  sources=()
  if [ -d "$ROOT/local/skills" ]; then
    for d in "$ROOT"/local/skills/*/; do
      [ -f "${d}SKILL.md" ] && sources+=("${d%/}")
    done
  fi
  if [ "$INCLUDE_KIT" -eq 1 ]; then
    for d in "$ROOT"/.agents/skills/*/; do
      [ -f "${d}SKILL.md" ] && sources+=("${d%/}")
    done
  fi
  if [ "${#sources[@]}" -eq 0 ]; then
    echo "링크할 스킬이 없습니다 (local/skills/<이름>/SKILL.md)."
    exit 0
  fi
  for src in "${sources[@]}"; do
    name="$(basename "$src")"
    link "$src" "$HOME/.agents/skills/$name"
    link "$src" "$HOME/.claude/skills/$name"
  done
fi

if [ "$CONFLICTS" -gt 0 ]; then
  echo "충돌 ${CONFLICTS}건은 건너뛰었습니다. 직접 확인한 뒤 다시 실행하세요." >&2
  exit 1
fi
