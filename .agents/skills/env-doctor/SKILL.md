---
name: env-doctor
description: portable-agent-kit 기준으로 현재 기기의 Claude Code, Codex, Gemini CLI 설정 상태(설치, 전역 지침 연결, 스킬 인식, MCP 등록과 인증)를 읽기 전용으로 점검하고 manifest와의 차이를 보고한다. 환경 점검, 설정 확인, 무엇이 빠졌는지 확인 요청에 사용한다.
---

# 환경 점검 (env-doctor)

키트 루트는 이 스킬의 상위 `.agents/skills/`를 가진 디렉터리다. `core/principles.md`, `core/adapters/*.md`, `local/environment.yaml`(있으면)을 읽는다. 이 스킬은 **아무것도 쓰지 않는다.**

## 점검 항목

| 영역 | 확인 방법 |
| --- | --- |
| 설치 | 각 에이전트의 `--version` |
| 키트 연결 | `CLAUDE.md`가 `@AGENTS.md`를 import하는지, `.claude/skills`가 `../.agents/skills` 링크인지, `.gemini/settings.json`의 `context.fileName`에 `AGENTS.md`가 있는지 |
| 전역 지침 | manifest의 대상 경로가 원본을 가리키는지, 끊어진 링크가 없는지 |
| 스킬 | manifest의 스킬이 각 에이전트 경로에 있는지. Gemini는 `gemini skills list --all`로 확인할 수 있다. 끊어진 링크와 이름 중복을 찾는다. |
| MCP | `claude mcp list`, `codex mcp list`, `gemini mcp list`의 등록 여부와 연결·인증 상태 |
| 도구 | `tools[].check` 명령 결과 |
| 저장소 | `local/.gitignore` 유무로 공개 키트인지 개인 인스턴스인지 판단하고, 개인 인스턴스라면 원격이 private인지 확인 |

목록 명령이 네트워크 연결을 시도하는 경우 시간이 걸릴 수 있다고 먼저 알린다. 명령 실패는 "점검 불가"로 표시하고 원인을 적는다.

## 보고

영역별로 `정상 / 차이 / 점검 불가`를 표로 보여준다. 차이마다 해결 방법(`env-apply` 항목, 수동 조치, `env-capture` 재실행)을 한 줄로 제시한다. manifest가 없으면 현재 상태만 보고하고 `env-capture`를 권한다.
