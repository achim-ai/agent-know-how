---
name: claude-code-allow-rules
description: Make Claude Code permission allow rules actually match, so allowed commands and file paths run without asking the user. Use when writing allow rules in settings.json, or when a command you allowed still shows a permission prompt.
compatibility: Claude Code
metadata:
  verified: "2026-11-25"
  verified-with: "Claude Code 2.1.311"
---

# Allow rules that match

An allow rule such as `"Bash(xcodebuild *)"` matches only when every part of the command matches. Chained or prefixed commands fall through to a prompt.

## Steps

1. Add rules to `permissions.allow` in `~/.claude/settings.json`, for example `"Bash(xcrun simctl *)"` and `"Bash(xcodebuild *)"`.
2. Run each allowed command on its own, exactly as the rule starts:
   - `xcodebuild -project App.xcodeproj …`, not `cd app && xcodebuild …`
   - not behind a variable assignment: `FOO=1 xcodebuild …`
   - not with a path prefix: `/usr/bin/xcodebuild …`
3. Instead of `cd`, use the tool's own directory option: `git -C <dir>`, `xcodebuild -project <path>`, `swift build --package-path <dir>`.
4. For file rules, write absolute paths with two slashes: `Read(//Users/<you>/project/**)`. One leading slash means relative to the settings file.

## Check

Run the command: it executes without a permission prompt.

## Pitfalls

- `Edit(...)` rules cover both Edit and Write; `Write(...)` rules never match. See [how path patterns match](https://code.claude.com/docs/en/permissions#how-path-patterns-match).
- A subagent's shell returns to its start folder on every call, so a tool that must run inside a project folder works only in the main session after a standalone `cd`.
- In a subagent, even a read-only command that matches no rule (`cd … ; cat …`) prompts.
