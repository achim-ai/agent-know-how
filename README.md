# agent-know-how

Field-tested agent skills for Claude Code, Codex and other coding agents: practical fixes for real setups that agents otherwise rediscover the hard way. Every skill says when it was last verified and on which versions.

## Use it

Claude Code:

```
/plugin marketplace add nohli/agent-know-how
/plugin install agent-know-how@agent-know-how
```

Any agent that reads [Agent Skills](https://agentskills.io) (Codex, Cursor, OpenCode and more):

```bash
npx skills add nohli/agent-know-how
```

Or copy a folder from [`skills/`](skills) into your agent's skills folder (for example `~/.claude/skills/`).

## Skills

| Skill | What it solves |
| --- | --- |
| [claude-desktop-open-links-in-browser](skills/claude-desktop-open-links-in-browser/SKILL.md) | Open `file://` links from Claude desktop replies in the default browser |
| [claude-chat-inline-screenshots](skills/claude-chat-inline-screenshots/SKILL.md) | Show screenshots inline in Claude desktop replies |
| [claude-code-allow-rules](skills/claude-code-allow-rules/SKILL.md) | Make permission allow rules match so commands run without prompts |
| [claude-prompt-free-simulators](skills/claude-prompt-free-simulators/SKILL.md) | Use iOS simulators from the Claude desktop app without device-access prompts |
| [macos-ui-tests-unattended](skills/macos-ui-tests-unattended/SKILL.md) | Run Mac UI tests without hanging on Automation Mode or a locked screen |
| [claude-calls-codex](skills/claude-calls-codex/SKILL.md) | Delegate from Claude to Codex, with a quota check first |
| [codex-calls-claude](skills/codex-calls-claude/SKILL.md) | Call Claude Code from Codex or scripts with a subscription login |
| [github-mark-notifications-done](skills/github-mark-notifications-done/SKILL.md) | Mark GitHub notifications as Done, not just read |
| [dev-disk-cleanup-macos](skills/dev-disk-cleanup-macos/SKILL.md) | Free disk space after development and test runs, safely |

## Contribute

Learned something the hard way? Add or fix a skill: see [CONTRIBUTING.md](CONTRIBUTING.md). Agents read [AGENTS.md](AGENTS.md).

## License

[BSD 3-Clause](LICENSE)
