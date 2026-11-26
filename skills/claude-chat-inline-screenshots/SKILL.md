---
name: claude-chat-inline-screenshots
description: Show screenshots and images inline in Claude desktop app replies, small but sharp and zoomable, instead of as links or file cards. Use when showing the user screenshots, UI changes or before/after comparisons in Claude Code's desktop app.
compatibility: Claude desktop app (Code tab)
metadata:
  verified: "2026-11"
  verified-with: "macOS 27.2.1, Claude Code 2.1.311 in the Claude desktop app"
---

# Inline screenshots in Claude desktop replies

Markdown images render in the chat only when the file is inside the session's working directory. The chat shows every image at its pixel size, so a full-resolution screenshot is too large and a plainly shrunk one is blurry. Show a sharpened quarter-size preview that links to the full-resolution file.

## Steps

1. Copy the screenshots into a Git-ignored folder inside the working directory, for example `.build/shots/`.
2. Make a preview at a quarter of the width (a phone screenshot becomes about 320 pixels wide):
   `swift scripts/thumbnail.swift .build/shots/home.png .build/shots/home-preview.jpg 0.25`
3. Embed the preview as a link to the full-resolution file, with paths relative to the working directory:
   `[![Home screen](.build/shots/home-preview.jpg)](.build/shots/home.png)`
4. For comparisons, use one table with the old image on the left and the new one on the right, both captured on the same device, appearance and language.

## Check

The reply shows a small, sharp image; clicking it opens the full-resolution screenshot.

## Pitfalls

- An absolute path or a path outside the working directory shows nothing.
- HTML `<img width>` and EXIF or PNG density metadata are ignored: the image still shows at its pixel size.
- Shrinking with `sips` alone blurs small text; use the script, which downscales with Lanczos and sharpens.
- Add the folder to `.gitignore` so screenshots don't get committed.
