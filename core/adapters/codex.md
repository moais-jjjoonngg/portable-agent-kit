# Codex CLI 어댑터

검증 기준: codex-cli 0.172 (2026-11-26).

| 항목 | 위치 / 명령 | 비고 |
| --- | --- | --- |
| 설정 홈 | `~/.codex` (환경변수 `CODEX_HOME`으로 변경 가능) | 셸 alias나 환경변수로 설정 파일 경로를 바꿨다면 manifest의 `config_path`에 기록한다. |
| 전역 지침 | `~/.codex/AGENTS.md` | 링크로 `local/instructions/global.md`를 연결한다. |
| 프로젝트 지침 | `AGENTS.md` | 기본 지원. |
| 전역 스킬 | `~/.agents/skills/<이름>/SKILL.md` | Gemini CLI와 공유되는 경로. |
| 프로젝트 스킬 | `.agents/skills/` | 인식 확인. |
| MCP | `codex mcp add ...` → `config.toml`의 `[mcp_servers.<name>]` | |
| 설정 | `config.toml` | 모델, 승인 정책, 기능 플래그. 비밀이 없는 키만 기록한다. |

## MCP 추가 예

```bash
codex mcp add <name> --url <url>
codex mcp add <name> --env API_KEY=$API_KEY -- <command> [args...]
```

## 수집하지 않는 것

`auth.json`, `history.jsonl`, `sessions/`, `archived_sessions/`, `*.sqlite`, `cache/`, `config.toml.bak*`.
