---
name: env-apply
description: portable-agent-kit의 환경 manifest(local/environment.yaml)를 새 기기나 현재 기기의 Claude Code, Codex, Gemini CLI에 적용한다. 기본은 dry-run이며 diff와 승인 후에만 전역 지침 링크, 스킬 링크, MCP 등록을 수행한다. 새 기기 설정, 환경 복원, 설정 동기화 요청에 사용한다.
---

# 환경 적용 (env-apply)

키트 루트는 이 스킬의 상위 `.agents/skills/`를 가진 디렉터리다. `AGENTS.md`, `core/principles.md`, `core/manifest.md`, `core/adapters/*.md`, `local/profile.md`(있으면), `local/environment.yaml`을 읽는다. manifest가 없으면 멈추고 `env-capture` 또는 예시 파일 복사를 안내한다.

## 0. 준비

- 키트 저장소에 커밋되지 않은 변경이 있으면 알린다. 원격이 있으면 fetch하고, 작업 트리가 깨끗하고 fast-forward 가능할 때만 동기화한다.
- 적용 대상 HOME을 확인한다. 사용자가 시험 적용을 원하면 임시 디렉터리를 HOME으로 지정해 진행한다.
- 각 에이전트의 설치 여부를 확인한다. 설치되지 않은 에이전트 항목은 "설치 필요"로 분류하고, `agents.*.install`이 있으면 명령만 제시한다.

## 1. 계획 작성 (dry-run)

manifest 항목마다 현재 상태를 확인해 표를 만든다.

| 분류 | 의미 |
| --- | --- |
| 일치 | 이미 같은 상태. 아무것도 하지 않는다. |
| 추가 | 대상이 없어 새로 만든다. |
| 변경 | 대상이 있고 내용이 다르다. 백업 후 교체한다. diff를 함께 보여준다. |
| 충돌 | 다른 링크, 다른 종류의 파일, 같은 이름 다른 설정의 MCP. 기본은 건너뛴다. |
| 수동 | OAuth 로그인, 환경변수 설정, 계정 커넥터, 원본 없는 스킬, 설치 필요 도구. |

이 단계에서는 아무것도 쓰지 않는다. 사용자가 항목 또는 분류 단위로 승인하면 2단계로 간다.

## 2. 적용

승인된 항목만 아래 순서로 적용한다. 바꾸는 파일은 먼저 `<파일>.pak-bak-<YYYYMMDDHHMMSS>`로 백업한다.

1. 전역 지침
   - `link`: 대상 디렉터리를 만들고 원본(`local/instructions/global.md`의 절대 경로)으로 심볼릭 링크를 만든다.
   - `import`: Claude 대상 파일에 `@<원본 절대 경로>` 한 줄이 없을 때만 추가한다.
2. 스킬
   - `origin: local`은 `scripts/link-skills.sh --global`로 에이전트별 전역 스킬 경로에 링크한다. 스크립트는 기존 항목을 덮어쓰지 않는다.
   - `origin: git`은 clone할 위치와 명령을 제시하고, 승인받으면 clone한 뒤 링크한다.
3. MCP: 어댑터 문서의 **공식 CLI 명령**으로 등록한다. 설정 파일을 직접 편집하지 않는다. 환경변수가 필요한 서버는 변수가 셸에 있는지 확인하고, 없으면 등록하지 않고 수동 항목으로 남긴다. `scope: account`는 건너뛴다.
4. 에이전트 설정: `agents.*.settings`의 키를 JSON/TOML 구조를 보존하며 병합한다. 다른 키는 건드리지 않는다.
5. 도구: 설치 명령은 사용자가 다시 확인한 경우에만 실행한다.

## 3. 확인과 보고

`env-doctor` 절차로 결과를 점검한다. 적용 / 건너뜀 / 실패 / 수동 항목, 만든 백업 경로, 사용자가 해야 할 일(OAuth 로그인, 환경변수, Gemini 폴더 신뢰 등)을 보고한다. 저장소를 커밋하지 않는다.

## 금지

- 비밀값 입력이나 저장, 인증 파일 복사
- 백업 없는 덮어쓰기, 충돌 항목 자동 해결
- 사용자 설정 파일의 다른 키 삭제나 재정렬
