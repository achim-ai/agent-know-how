---
name: claude-calls-codex
description: Delegate work from Claude Code (or any script) to OpenAI Codex on a Mac with the ChatGPT app installed - one-shot codex exec runs, a weekly-quota check before starting, and chats that show up in the Codex app. Use when Claude should hand a task to Codex.
compatibility: macOS with the ChatGPT desktop app signed in
metadata:
  verified: "2026-11"
  verified-with: "macOS 27.2.1, codex-cli 0.171.0-alpha.13.2 bundled with the ChatGPT app"
---

# Claude calls Codex

## Steps

1. Use the Codex CLI bundled with the ChatGPT app. A Homebrew `codex` can lag behind and reject current models.

   ```bash
   CODEX=/Applications/ChatGPT.app/Contents/Resources/codex-cli/bin/codex
   ```

2. Check the weekly quota first. The response also contains account details, so print only the usage fields:

   ```bash
   printf '%s\n' \
     '{"id":1,"method":"initialize","params":{"clientInfo":{"name":"quota_check","version":"1.0"}}}' \
     '{"method":"initialized","params":{}}' \
     '{"id":2,"method":"account/rateLimits/read","params":{}}' \
     | (cat; sleep 4) | "$CODEX" app-server 2>/dev/null \
     | jq -c 'select(.id == 2) | [.result.rateLimitsByLimitId // .result.rateLimits | .. | objects | select(has("usedPercent")) | {usedPercent, windowDurationMins, resetsAt}]'
   ```

   `usedPercent` is the share already used; `windowDurationMins` 10080 is the weekly window and `resetsAt` is in Unix seconds. Skip Codex when the weekly share is too high or the check prints nothing.
3. Run a task and keep the final answer:

   ```bash
   "$CODEX" exec -m <model> -c model_reasoning_effort="high" -C /abs/path/to/repo -s workspace-write -o /tmp/<task>-answer.txt "<task>"
   ```

4. If the user should see the chat in the Codex app, start it through `"$CODEX" app-server` with `thread/start`, `thread/name/set` and `turn/start` instead. Set the model, effort and `cwd` explicitly. `cwd` must be exactly a project folder the app already knows; a subfolder or worktree puts the chat under "No project", so keep `cwd` at the project folder and name the real working folder as an absolute path in the prompt. `"$CODEX" app-server generate-json-schema` prints the exact request formats.
5. When the work is verified and its result saved, archive the chat with `"$CODEX" archive <id>`, then confirm through `thread/list` in `app-server` that it is archived.

## Check

`exec` exits 0 and the `-o` file holds Codex's final answer.

## Pitfalls

- Chats started with `codex exec` don't appear in the Codex app's default chat list.
- Never print or log the full rate-limit response: besides the usage numbers it contains account identifiers and credit details.
- If `thread/archive` reports an active writer, another process still has the chat open.
