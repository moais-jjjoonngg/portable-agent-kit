# Gemini CLI 어댑터

검증 기준: Gemini CLI 0.42 (2026-11-26).

| 항목 | 위치 / 명령 | 비고 |
| --- | --- | --- |
| 설정 | `~/.gemini/settings.json` | `mcpServers`, `hooks`, `context.fileName` 등. |
| 컨텍스트 파일명 | `context.fileName` | 기본은 `GEMINI.md`. `["AGENTS.md", "GEMINI.md"]`로 두면 `AGENTS.md`를 읽는다. 이 키트는 `.gemini/settings.json`으로 설정한다. |
| 전역 지침 | `~/.gemini/<context 파일명>` | 예: `~/.gemini/AGENTS.md`. 링크로 `local/instructions/global.md`를 연결한다. |
| 전역 스킬 | `~/.agents/skills/` | Codex와 공유. 인식 확인. |
| 프로젝트 스킬 | `.agents/skills/`, `.gemini/skills/` | 인식 확인. **신뢰된 폴더(trusted folder)에서만** 로드된다. |
| 스킬 관리 | `gemini skills list --all`, `gemini skills link <path>` | |
| MCP | `gemini mcp add -s user ...` → `settings.json`의 `mcpServers` | 기본 scope가 `project`이므로 전역은 `-s user`를 명시한다. |

## 미검증

- 신뢰하지 않은 폴더에서는 프로젝트 `.gemini/settings.json`(따라서 `context.fileName`)이 적용되지 않을 수 있다. 처음 열 때 폴더를 신뢰해야 한다. 이 동작은 아직 외부 사용자 환경에서 검증하지 않았다.

## MCP 추가 예

```bash
gemini mcp add -s user -t http <name> <url>
gemini mcp add -s user -e API_KEY=$API_KEY <name> <command> [args...]
```

## 수집하지 않는 것

`history/`, `tmp/`, `state.json`, `installation_id`, `projects.json`, `trustedFolders.json`(기기별 경로), `settings.json.bak*`, 인증 정보.
