# portable-agent-kit

[한국어](README.md)

> **For AI agents**: if the user gives this repository URL (or a repository created from this kit) with `셋팅 시작` or `시작`, clone it to `~/<repo name>` and follow the short-command table in its `AGENTS.md`.

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
| `.agents/skills/` | Kit skills: `agent-setup` (셋팅 시작), `env-capture`, `env-apply` (시작), `env-doctor`. Claude reads them through the `.claude/skills` symlink. |
| `core/` | Shared principles, per-agent adapters, and the manifest spec |
| `local/` | User-owned area: profile, global instructions, personal skills, `environment.yaml` |
| `scripts/` | `link-skills.sh` (skill symlinks) and `check-leaks.sh` (leak check) |

## Usage

Type one line to any of Claude Code, Codex, or Gemini CLI. The commands are Korean keywords: **셋팅 시작** ("start setup") and **시작** ("start").

| When | Type |
| --- | --- |
| **First registration** (save this machine's setup) | `https://github.com/moais-jjjoonngg/portable-agent-kit 셋팅 시작` |
| **Moving to another machine** | `<your private repo URL> 시작` (or just `시작` inside a cloned folder) |

- **셋팅 시작**: clones the kit, creates your **private** repository, captures this machine's instructions, skills, and MCP setup without secrets, and pushes it. It asks only for the repo name, language, and whether to enable the daily-work module.
- **시작**: clones your repository, shows the differences from this machine, and applies them after one approval. If nothing changed since the last apply, it skips right away.
- You can also ask for `env-doctor` (check) or `env-capture` (re-capture).

Gemini CLI loads project skills only from trusted folders, so trust the folder the first time you open it.

<details>
<summary>Manual setup</summary>

```bash
git clone https://github.com/moais-jjjoonngg/portable-agent-kit.git agent-env
cd agent-env
git remote rename origin upstream          # keep history to receive kit updates
gh repo create agent-env --private --source . --remote origin --push
git rm local/.gitignore                     # track your personal files
cp local/profile.example.md local/profile.md
```

GitHub does not allow private forks of public repositories, so this is the way to stay private and updatable. **Use this template** breaks the history link.

</details>

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

## Optional modules

| Module | What it does | Enable |
| --- | --- | --- |
| [daily-work](modules/daily-work/README.md) | Evidence-based daily work log and cross-machine handoff (`daily-work-resume`, `daily-work-record`) | `scripts/link-skills.sh --module daily-work` |

## License

[MIT](LICENSE)
