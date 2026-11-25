---
name: claude-calls-codex
description: Delegate work from Claude Code (or any script) to OpenAI Codex on a Mac with the ChatGPT app installed - one-shot codex exec runs, a weekly-quota check before starting, and chats that show up in the Codex app. Use when Claude should hand a task to Codex.
compatibility: macOS with the ChatGPT desktop app signed in
metadata:
  verified: "2026-11-25"
  verified-with: "macOS 27.2.1, codex-cli 0.171.0-alpha.13.2 bundled with the ChatGPT app"
---

# Claude calls Codex

## Steps

1. Use the Codex CLI bundled with the ChatGPT app. A Homebrew `codex` can lag behind and reject current models.

   ```bash
   CODEX=/Applications/ChatGPT.app/Contents/Resources/codex-cli/bin/codex
   ```

2. Check the weekly quota first. `usedPercent` is the share already used; skip Codex when it is too high:

   ```bash
   printf '%s\n' \
     '{"id":1,"method":"initialize","params":{"clientInfo":{"name":"quota_check","version":"1.0"}}}' \
     '{"method":"initialized","params":{}}' \
     '{"id":2,"method":"account/rateLimits/read","params":{}}' \
     | (cat; sleep 4) | "$CODEX" app-server \
     | grep '"id":2'
   ```

   Read `result.rateLimits.primary.usedPercent` (its `windowDurationMins` 10080 is the weekly window).
3. Run a task and keep the final answer:

   ```bash
   "$CODEX" exec -m <model> -c model_reasoning_effort="high" -C /abs/path/to/repo -s workspace-write -o /tmp/<task>-answer.txt "<task>"
   ```

4. If the user should see the chat in the Codex app, start it through `"$CODEX" app-server` with `thread/start`, `thread/name/set` and `turn/start` instead. Set the model, effort and `cwd` explicitly; `cwd` must be a project folder the app already knows, or the chat lands under "No project". `"$CODEX" app-server generate-json-schema` prints the exact request formats.

## Check

`exec` exits 0 and the `-o` file holds Codex's final answer.

## Pitfalls

- Chats started with `codex exec` don't appear in the Codex app's default chat list.
- Don't print the full rate-limit response into logs: it also contains account details.
