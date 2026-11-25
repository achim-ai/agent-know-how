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

2. For a read-only review, start from an empty working folder, pass the prompt on standard input and allow only Read inside the repository:

   ```bash
   claude --print --model opus --effort high --output-format json --tools Read --permission-mode dontAsk --no-session-persistence \
     --setting-sources '' --settings settings.json --mcp-config mcp.json --strict-mcp-config \
     --add-dir /abs/path/to/repo < prompt.txt
   ```

   - `mcp.json` is `{"mcpServers":{}}`, so no MCP servers load.
   - `settings.json` sets `permissions.blockReadsOutsideWorkingDirectories` to `true`; then Claude reads only inside the `--add-dir` folders. Allow-rule paths there need two leading slashes (`Read(//Users/<you>/repo/**)`).
   - `--safe-mode` is a shorter alternative: it starts without your customizations but keeps the login.
   - Ask for a fixed marker word at the end of the answer, and let Claude read the files itself instead of pasting their contents into the prompt.

3. To let Claude edit, allow the editing tools too and still limit it to that one repository with `--add-dir`. Review the resulting diff yourself.

## Check

The JSON result has `"is_error": false`, an empty `permission_denials` list, the marker word, and `modelUsage` names the model you asked for.

## Pitfalls

- Don't use `--bare` with a subscription: it skips Keychain reads and accepts only `ANTHROPIC_API_KEY`, so the subscription login fails.
- Without step 2's options, each call loads your full Claude setup (CLAUDE.md, plugins, MCP servers), which can be well over 100,000 tokens. Use the plain step 1 call only to test the login.
- A run that exits 0 but read no files, or lists permission denials, didn't actually review anything.
- `Failed to authenticate: OAuth session expired and could not be refreshed` means the user has to sign in to Claude again; retrying the same call doesn't help.
