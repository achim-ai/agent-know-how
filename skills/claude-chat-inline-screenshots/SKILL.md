---
name: claude-chat-inline-screenshots
description: Show screenshots and images inline in Claude desktop app replies instead of as links or file cards. Use when showing the user screenshots, UI changes or before/after comparisons in Claude Code's desktop app.
compatibility: Claude desktop app (Code tab)
metadata:
  verified: "2026-11-25"
  verified-with: "macOS 27.2.1, Claude Code 2.1.311 in the Claude desktop app"
---

# Inline screenshots in Claude desktop replies

Markdown images render in the chat only when the file is inside the session's working directory. Images elsewhere, such as `/private/tmp`, don't render.

## Steps

1. Copy the images into a Git-ignored folder inside the working directory, for example `.build/shots/`.
2. Embed them with a path relative to the working directory: `![Home screen](.build/shots/home.png)`.
3. Use full-resolution images so the user can click to zoom.
4. For comparisons, use one table with the old image on the left and the new one on the right, both captured on the same device, appearance and language.

## Check

The image shows in the reply itself, not as a link.

## Pitfalls

- An absolute path or a path outside the working directory shows nothing.
- Add the folder to `.gitignore` so screenshots don't get committed.
