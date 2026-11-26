# portable-agent-kit

[English](README.en.md)

여러 기기를 옮겨 다니며 **Claude Code, Codex, Gemini CLI**를 쓰는 사람이 AI 작업 환경(전역 지침, 스킬, MCP 서버, hooks, 관련 도구)을 비밀 없이 기록하고 새 기기에 안전하게 옮기기 위한 키트입니다.

## 무엇을 해결하나

- 전역 지침과 스킬이 `~/.claude`, `~/.codex`, `~/.gemini`, `~/.agents`에 흩어져 있고, 새 기기에서 다시 만들기 어렵다.
- 에이전트마다 지침 파일 이름과 MCP 등록 방식이 다르다.
- 설정을 저장소에 올리다 토큰이나 개인 경로가 섞이기 쉽다.

## 구성

| 경로 | 내용 |
| --- | --- |
| `AGENTS.md` | 모든 에이전트의 단일 지침 원천. Claude는 `CLAUDE.md`의 `@AGENTS.md`로, Gemini는 `.gemini/settings.json`으로 읽는다. |
| `.agents/skills/` | 키트 스킬: `env-capture`(수집), `env-apply`(적용), `env-doctor`(점검). Claude는 `.claude/skills` 링크로 읽는다. |
| `core/` | 공통 원칙, 에이전트별 어댑터, manifest 명세 |
| `local/` | 사용자 소유 영역(개인 프로필, 전역 지침, 개인 스킬, `environment.yaml`) |
| `scripts/` | `link-skills.sh`(스킬 링크), `check-leaks.sh`(유출 검사) |

## 시작하기

1. 키트를 clone하고, 히스토리를 유지한 채 개인 **private** 저장소로 올립니다. 그래야 나중에 키트 업데이트를 병합할 수 있습니다.
   ```bash
   git clone https://github.com/moais-jjjoonngg/portable-agent-kit.git my-agent-env
   cd my-agent-env
   git remote rename origin upstream
   gh repo create my-agent-env --private --source . --push
   ```
   GitHub는 public 저장소의 private fork를 허용하지 않으므로 이 방식을 씁니다. **Use this template**은 히스토리가 끊겨 업데이트를 받을 수 없으니, 업데이트가 필요 없을 때만 쓰세요.
2. 개인 설정을 추적하도록 `local/.gitignore`를 삭제하고 커밋합니다.
3. 예시 파일을 복사합니다.
   ```bash
   cp local/profile.example.md local/profile.md
   cp local/instructions/global.example.md local/instructions/global.md
   ```
4. **기존 기기**에서 저장소 폴더를 열고 에이전트에게 요청합니다.
   > 지금 기기의 AI 환경을 수집해줘 (env-capture)
5. 결과(`local/`)를 확인해 커밋·push합니다.
6. **새 기기**에서 clone한 뒤 요청합니다.
   > 이 환경을 적용해줘 (env-apply)

   먼저 변경 계획만 보여주고, 승인한 항목만 적용합니다.
7. 언제든 점검할 수 있습니다.
   > 환경 점검해줘 (env-doctor)

Gemini CLI는 신뢰한 폴더(trusted folder)에서만 프로젝트 스킬을 읽습니다. 처음 열 때 폴더를 신뢰하도록 설정하세요.

## 키트 업데이트 받기

```bash
git fetch upstream
git merge upstream/main
```

키트 업데이트는 `local/`의 예시 파일(`*.example.*`, `README.md`) 외에는 사용자 파일을 바꾸지 않으므로 대부분 충돌 없이 병합됩니다. 삭제한 `local/.gitignore`가 다시 생기면 삭제 상태를 유지하세요.

## 안전 원칙

- 비밀값(토큰, API 키, 헤더, 비밀번호)은 기록하지 않습니다. 환경변수 이름만 남깁니다.
- 사용자 설정 파일은 diff와 승인 뒤에만 바꾸고, 바꾸기 전에 `*.pak-bak-<시각>` 백업을 남깁니다.
- 공개 전에는 `scripts/check-leaks.sh --history`를 실행합니다. 개인 금지어는 `local/leak-patterns.txt`에 정규식으로 추가합니다.

자세한 내용은 [core/principles.md](core/principles.md)와 [core/manifest.md](core/manifest.md)를 참고하세요.

## 지원 범위

| 에이전트 | 검증 버전 |
| --- | --- |
| Claude Code | 2.1.x |
| Codex CLI | 0.172 |
| Gemini CLI | 0.42 |

## 선택 모듈

| 모듈 | 내용 | 켜기 |
| --- | --- | --- |
| [daily-work](modules/daily-work/README.md) | 근거 기반 일일 업무 기록과 기기 간 인수인계(`daily-work-resume`, `daily-work-record`) | `scripts/link-skills.sh --module daily-work` |

## 라이선스

[MIT](LICENSE)
