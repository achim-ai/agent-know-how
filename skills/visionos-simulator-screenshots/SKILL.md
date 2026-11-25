---
name: visionos-simulator-screenshots
description: Capture Vision Pro (visionOS) simulator screenshots that include presented sheets and windows. Use when XCTest screenshots on visionOS show only the underlying window or crop a presented sheet.
compatibility: macOS with Xcode and a visionOS simulator runtime
metadata:
  verified: "2026-11"
  verified-with: "Xcode 27.2, visionOS 27.2 simulator"
---

# Vision Pro screenshots with sheets

An XCTest screenshot of the app can show only the cropped underlying window while a sheet is presented. The simulator's own capture of the active display shows what's really on screen.

## Steps

1. Bring the app to the state you want, with the sheet presented.
2. While the sheet is still shown, capture the display:

   ```bash
   xcrun simctl io <udid> screenshot --display=1 --type=png <file>.png
   ```

## Check

Open the PNG: the sheet is visible and not cropped.

## Pitfalls

- On simulators with several displays, pick the active one.
- Decode every capture and reject empty or placeholder images before using them.
