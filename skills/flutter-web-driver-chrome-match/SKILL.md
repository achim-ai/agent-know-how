---
name: flutter-web-driver-chrome-match
description: Fix Flutter web integration tests that fail to start because ChromeDriver and Chrome versions don't match, or flutter drive uses the wrong browser. Use before running flutter drive on web, locally or in CI.
compatibility: Flutter web integration tests with ChromeDriver
metadata:
  verified: "2026-11"
  verified-with: "Flutter 3.50, Homebrew chromedriver"
---

# ChromeDriver and Chrome must match

ChromeDriver and Chrome are a pair: their major versions must match.

## Steps

1. Compare the majors: `chromedriver --version` and your Chrome version.
2. Homebrew's `chromedriver` cask often lags behind auto-updated Chrome. Upgrade it (`brew upgrade --cask chromedriver`) and compare again.
3. Tell `flutter drive` which browser to use:

   ```bash
   flutter drive -d web-server --chrome-binary "<path to Chrome binary>" --driver <driver.dart> --target <test.dart>
   ```

## Check

The browser opens and the first test step runs.

## Pitfalls

- `CHROME_EXECUTABLE` alone doesn't choose WebDriver's browser; pass `--chrome-binary`.
- In CI, use the runner's preinstalled browser and driver pair. Never replace only the driver with a `latest` version.
- Keep normal browser security so requests send their `Origin` header.
