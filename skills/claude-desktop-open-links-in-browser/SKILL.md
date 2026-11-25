---
name: claude-desktop-open-links-in-browser
description: Make file:// links in Claude desktop app replies open in the Mac's default browser or default app instead of the app's built-in browser pane. Use when giving the user a clickable link to a local HTML page, report or file in the Claude desktop app on macOS.
compatibility: Claude desktop app (Code tab) on macOS
metadata:
  verified: "2026-11-25"
  verified-with: "macOS 27.2.1, Claude Code 2.1.311 in the Claude desktop app"
---

# Open local links in the system browser

In the Claude desktop app, a clicked `file://` link opens in the built-in browser pane. The small mod in [`assets/`](assets) hands it to macOS `open` instead, so HTML opens in the default browser and other files in their default app. Web links keep the app's behavior.

## Steps

1. Copy this skill's `assets/` folder to a permanent place, for example `~/claude-mods`.
2. Install it:

   ```bash
   claude plugin marketplace add "$HOME/claude-mods"
   claude plugin install open-local-links@local-mods
   ```

3. Run `/reload-plugins` or start a new session.
4. Write links as Markdown with absolute file URLs: `[Report](file:///Users/<you>/project/report/index.html)`.

## Check

Click the link in a reply: it opens in the default browser, not in the app's side pane.

## Pitfalls

- Only Markdown links `[label](file://…)` are handled. A bare path or a `localhost` URL still opens in the app.
- A space in the path ends the link: encode it as `%20`.
- Edits to the mod reach running sessions only after `/reload-plugins`.
