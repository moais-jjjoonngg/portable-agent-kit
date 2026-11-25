---
name: env-capture
description: 현재 기기의 Claude Code, Codex, Gemini CLI 설정(전역 지침, 스킬, MCP, hooks, 의존 CLI 도구)을 비밀 없이 읽어 portable-agent-kit의 환경 manifest(local/environment.yaml)로 기록한다. 기존 기기 설정 백업, 기기 이전 준비, 환경 스냅샷, 현재 AI 설정 정리 요청에 사용한다.
---

# 환경 수집 (env-capture)

키트 루트는 이 스킬의 상위 `.agents/skills/`를 가진 디렉터리다. 먼저 `AGENTS.md`, `core/principles.md`, `core/manifest.md`, `core/adapters/*.md`, `local/profile.md`(있으면)를 읽는다. 이 스킬은 사용자 설정을 **읽기만** 하고, 저장소의 `local/` 아래 파일만 쓴다.

## 1. 에이전트 확인

에이전트마다 실행 파일 위치와 버전(`claude --version`, `codex --version`, `gemini --version`)을 확인한다. 설치되지 않은 에이전트는 `installed: false`로 기록하고 건너뛴다. `CODEX_HOME`처럼 설정 경로를 바꾸는 환경변수나 셸 alias가 있으면 경로만 기록한다.

## 2. 전역 지침

어댑터 문서의 전역 지침 위치를 확인한다.

- 대상이 이미 `local/instructions/global.md`로 향하는 링크이면 `mode: link`로 기록한다.
- 일반 파일이면 내용을 보여주고, 원본으로 가져올지 사용자에게 묻는다. 에이전트마다 내용이 다르면 차이를 요약하고 하나로 합칠지 따로 둘지 제안한다. 승인 전에는 `local/instructions/`에 쓰지 않는다.
- 회사나 특정 저장소 전용 규칙으로 보이는 부분은 표시해 두고, 전역 지침에 남길지 사용자가 정하게 한다.

## 3. 스킬

`~/.claude/skills`, `~/.agents/skills`, `~/.codex/skills`, `~/.gemini/skills`를 확인한다. 같은 이름은 하나로 합치고 어느 에이전트에서 보이는지 `agents`에 적는다.

- 링크면 대상 경로를 확인한다. 키트의 `local/skills/`를 가리키면 `origin: local`이다.
- 디렉터리가 git 저장소 안에 있으면 `origin: git`과 remote URL, 하위 경로를 적는다.
- 에이전트 내장 스킬은 `origin: builtin`이며 복원 대상이 아니다.
- 그 외 일반 디렉터리는 `local/skills/`로 옮길 후보로 보고한다. 이동은 사용자가 승인한 경우에만 한다(원래 위치에는 링크를 남긴다).

## 4. MCP

- Claude: `claude mcp list`, `claude mcp get <name>`. 이름이 `claude.ai `로 시작하면 `scope: account`.
- Codex: `config.toml`의 `[mcp_servers.*]`.
- Gemini: `settings.json`의 `mcpServers`.

같은 서버(같은 URL 또는 같은 command+args)는 하나로 합친다. 기록하는 것은 이름, transport, URL, command, args, 환경변수 **이름**, 인증 방식이다. 헤더·env 값·토큰처럼 보이는 args는 기록하지 않고 `env`에 이름으로만 남기거나 `note`에 "비밀 인자 제외"라고 적는다. command가 홈 아래 절대 경로면 `~`로 바꾸고 재설치 방법을 아는 경우에만 `install`을 적는다.

## 5. hooks와 도구

각 에이전트 설정의 hooks에서 이벤트명과 실행 명령 이름만 기록한다(스크립트 내용 제외). hooks나 전역 지침이 의존하는 CLI 도구는 `tools`에 확인 명령과 함께 적는다. 설치 명령은 확인된 경우에만 쓴다.

## 6. 저장과 보고

- `local/environment.yaml`이 있으면 기존 `note`와 사용자가 직접 쓴 값을 보존하며 병합한다. 사라진 항목은 지우지 말고 `last_seen`을 유지한 채 "이번 수집에서 미발견"으로 보고한다.
- 쓰기 전에 diff를 보여준다. 쓴 뒤에는 비밀 패턴(토큰 접두사, `Bearer`, `key=`, 이메일)을 검사하고 `scripts/check-leaks.sh`를 실행한다.
- 커밋하지 않는다. 변경 파일, 수집 실패 항목, `local/`로 옮길 후보, 사용자가 결정할 항목을 보고한다.
