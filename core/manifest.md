# 환경 manifest 명세 (`local/environment.yaml`)

한 사람의 AI 작업 환경을 기기와 무관하게 기술한다. `env-capture`가 만들고 `env-apply`·`env-doctor`가 읽는다. 예시는 `local/environment.example.yaml`.

## 최상위 키

| 키 | 필수 | 설명 |
| --- | --- | --- |
| `version` | O | 명세 버전. 현재 `1`. |
| `captured` | O | 마지막 수집 정보: `at`(ISO 8601), `host_label`(기기를 구분할 별칭, 실제 호스트명 불필요). |
| `instructions` | | 전역 지침 원본과 에이전트별 연결 방식. |
| `skills` | | 개인 스킬 목록. |
| `mcp` | | MCP 서버 목록. |
| `tools` | | 에이전트 설정이 의존하는 CLI 도구. |
| `agents` | | 에이전트별 설치 방법, 설정 경로, hooks 요약, 메모. |

## instructions

```yaml
instructions:
  source: local/instructions/global.md   # 저장소 기준 상대 경로
  targets:
    claude: { path: ~/.claude/CLAUDE.md, mode: import } # link | import | manual
    codex:  { path: ~/.codex/AGENTS.md,  mode: link }
    gemini: { path: ~/.gemini/AGENTS.md, mode: link }
```

- `link`: 대상 경로를 원본으로 향하는 심볼릭 링크로 만든다. 저장소를 pull하면 모든 에이전트에 반영된다.
- `import`: Claude 전용이며 Claude의 기본값. 대상 파일에 `@<원본 절대 경로>` 한 줄을 둔다. 대상 파일의 다른 내용은 유지된다.

Claude에서 `link`를 쓰면 원본 안의 상대 경로 import(예: `@RULES.md`)가 링크 위치 기준으로 해석될 수 있다. 이 동작은 검증되지 않았으므로 Claude는 `import`를 권장한다.
- `manual`: 사용자가 직접 관리한다. 비교만 한다.

## skills

```yaml
skills:
  - name: my-skill
    origin: local            # local | git | builtin
    path: local/skills/my-skill
    agents: [claude, codex, gemini]
  - name: shared-skill
    origin: git
    repo: https://github.com/<owner>/<repo>
    subpath: skills/shared-skill
    agents: [codex, gemini]
```

`origin: local`은 이 저장소에 원본이 있어야 한다. 원본이 없는 스킬은 `origin: unknown`과 `note`로 남기고 복원 대상에서 제외한다.

## mcp

```yaml
mcp:
  - name: docs-server
    transport: http          # http | sse | stdio
    url: https://example.com/mcp
    auth: oauth              # oauth | env | none
    agents: [claude, codex, gemini]
  - name: local-tool
    transport: stdio
    command: npx
    args: ["-y", "example-mcp@1.2.3"]
    env: [EXAMPLE_API_KEY]   # 이름만. 값은 쓰지 않는다.
    agents: [claude]
  - name: claude.ai Example
    scope: account           # 계정 커넥터. 적용 대상 아님.
    agents: [claude]
```

stdio 서버의 `command`가 기기 고유 절대 경로면 `~`로 바꾸고 `install` 키에 재설치 방법을 적는다. 알 수 없으면 `install: unverified`.

## tools / agents

```yaml
tools:
  - name: example-cli
    check: example-cli --version
    install: brew install example-cli
    used_by: [claude-hooks]
agents:
  claude:
    install: npm install -g @anthropic-ai/claude-code
    hooks: [{ event: PreToolUse, command: example-cli }]
  codex:
    config_path: ~/.codex/config.toml
  gemini:
    settings: { context.fileName: ["AGENTS.md", "GEMINI.md"] }
```

`agents.*.settings`에는 비밀이 아닌 키만 점 표기로 기록한다.
