---
name: codex-calls-claude
description: Call Claude Code non-interactively from Codex or a script with a Claude subscription login, including a read-only review scoped to one repository. Use when Codex or another agent wants a second opinion or work from Claude.
compatibility: Claude Code CLI signed in with a Claude subscription
metadata:
  verified: "2026-11-25"
  verified-with: "Claude Code 2.1.311 on macOS 27.2.1"
---

# Codex calls Claude

## Steps

1. Check that the login works (returns JSON with `"is_error": false`):

   ```bash
   claude --print --model opus --effort high --tools '' --permission-mode dontAsk --no-session-persistence --output-format json 'Return exactly READY. Do not use tools.'
   ```

2. For a read-only review, pass the prompt on standard input and allow only Read inside the repository:

   ```bash
   claude --print --model opus --effort high --output-format json --tools Read --permission-mode dontAsk --no-session-persistence --add-dir /abs/path/to/repo < prompt.txt
   ```

3. To let Claude edit, allow the editing tools too and still limit it to that one repository with `--add-dir`.

## Check

The JSON result has `"is_error": false`, an empty `permission_denials` list, and the answer you asked for.

## Pitfalls

- Don't use `--bare` with a subscription: it skips Keychain reads and accepts only `ANTHROPIC_API_KEY`, so the subscription login fails.
- Each call loads your full Claude setup (CLAUDE.md, plugins, MCP servers), which can cost a lot of tokens. `--setting-sources ''` with an explicit `--settings <file>` and `--mcp-config <file> --strict-mcp-config` keeps it small.
- A run that exits 0 but read no files, or lists permission denials, didn't actually review anything.
