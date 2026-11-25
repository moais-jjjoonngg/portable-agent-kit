# Claude Code 어댑터

검증 기준: Claude Code 2.1.x (2026-11-26).

| 항목 | 위치 / 명령 | 비고 |
| --- | --- | --- |
| 전역 지침 | `~/.claude/CLAUDE.md` | `@경로` import 지원. 기본은 `@<local/instructions/global.md 절대 경로>` 한 줄을 추가하는 `import` 방식이다. 심볼릭 링크 방식은 미검증. |
| 프로젝트 지침 | `CLAUDE.md` | `AGENTS.md`를 직접 읽지 않으므로 `@AGENTS.md` 한 줄을 둔다. |
| 전역 스킬 | `~/.claude/skills/<이름>/SKILL.md` | 심볼릭 링크 인식 확인. |
| 프로젝트 스킬 | `.claude/skills/` | `../.agents/skills` 링크로 인식 확인. |
| MCP (user) | `claude mcp add -s user ...` → `~/.claude.json`의 `mcpServers` | 파일을 직접 편집하지 말고 CLI를 쓴다. |
| MCP (project) | `.mcp.json` | 저장소에 커밋되므로 비밀 금지. |
| 계정 커넥터 | 이름이 `claude.ai `로 시작하는 서버 | 계정에 묶여 로그인 시 따라온다. manifest에는 `scope: account`로만 기록하고 적용 대상에서 제외한다. |
| 설정 | `~/.claude/settings.json` | hooks, permissions, env. hooks는 이벤트명과 실행 명령 이름만 기록한다. |

## MCP 추가 예

```bash
claude mcp add -s user --transport http <name> <url>
claude mcp add -s user <name> -e API_KEY=$API_KEY -- <command> [args...]
```

## 수집하지 않는 것

`~/.claude/projects/`, `history.jsonl`, `sessions/`, `cache/`, `telemetry/`, 인증·정책 파일.
