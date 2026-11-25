# portable-agent-kit

[한국어](README.md)

A kit for people who move between machines and use **Claude Code, Codex, and Gemini CLI**. It records your AI setup (global instructions, skills, MCP servers, hooks, and supporting tools) without secrets, and applies it safely on a new machine.

> The kit's agent instructions and skills are written in Korean. Agents follow them regardless of your language, and you can set your response language in `local/profile.md`.

## Why

- Global instructions and skills are scattered across `~/.claude`, `~/.codex`, `~/.gemini`, and `~/.agents`, and are hard to rebuild on a new machine.
- Each agent uses different instruction file names and MCP registration methods.
- Putting configs in a repo makes it easy to leak tokens or personal paths.

## Layout

| Path | Contents |
| --- | --- |
| `AGENTS.md` | The single instruction source for every agent. Claude reads it through `@AGENTS.md` in `CLAUDE.md`, and Gemini through `.gemini/settings.json`. |
| `.agents/skills/` | Kit skills: `env-capture`, `env-apply`, `env-doctor`. Claude reads them through the `.claude/skills` symlink. |
| `core/` | Shared principles, per-agent adapters, and the manifest spec |
| `local/` | User-owned area: profile, global instructions, personal skills, `environment.yaml` |
| `scripts/` | `link-skills.sh` (skill symlinks) and `check-leaks.sh` (leak check) |

## Getting started

1. Clone the kit and push it to your own **private** repository with history intact, so you can merge kit updates later.
   ```bash
   git clone https://github.com/moais-jjjoonngg/portable-agent-kit.git my-agent-env
   cd my-agent-env
   git remote rename origin upstream
   gh repo create my-agent-env --private --source . --push
   ```
   GitHub does not allow private forks of public repositories, so this is the way to stay both private and updatable. **Use this template** breaks the history link, so use it only if you don't need updates.
2. Delete `local/.gitignore` so your personal files are tracked, then commit.
3. Copy the examples:
   ```bash
   cp local/profile.example.md local/profile.md
   cp local/instructions/global.example.md local/instructions/global.md
   ```
4. **On your current machine**, open the repo folder and ask your agent:
   > Capture this machine's AI environment (env-capture)
5. Review the files under `local/`, then commit and push.
6. **On a new machine**, clone the repo and ask:
   > Apply this environment (env-apply)

   The skill shows a plan first and applies only the items you approve.
7. Check your setup at any time:
   > Run env-doctor

Gemini CLI loads project skills only from trusted folders, so trust the folder the first time you open it.

## Getting kit updates

```bash
git fetch upstream
git merge upstream/main
```

Kit updates change only the example files in `local/` (`*.example.*`, `README.md`) and never your own files, so merges are usually conflict-free. If the deleted `local/.gitignore` comes back, delete it again.

## Safety

- Secrets (tokens, API keys, headers, passwords) are never written. Only environment variable names are recorded.
- User config files are changed only after you see a diff and approve it, and a `*.pak-bak-<timestamp>` backup is made first.
- Before publishing, run `scripts/check-leaks.sh --history`. Add your own forbidden terms as regexes to `local/leak-patterns.txt`.

## Supported agents

| Agent | Verified version |
| --- | --- |
| Claude Code | 2.1.x |
| Codex CLI | 0.172 |
| Gemini CLI | 0.42 |

## Roadmap

- Optional module: daily work log and cross-machine handoff (day-start / day-end)

## License

[MIT](LICENSE)
