---
name: flutter-web-driver-chrome-match
description: Fix Flutter web integration tests that fail to start because ChromeDriver and Chrome versions don't match - upgrade the driver or install the matching one from Chrome for Testing, start it on a port and point flutter drive at it. Use before running flutter drive on web, locally or in CI, or when it fails with session not created.
compatibility: Flutter web integration tests with ChromeDriver
metadata:
  verified: "2026-11"
  verified-with: "Flutter 3.50, Chrome 156 with ChromeDriver 156 from Chrome for Testing; lookup checked with Chrome 157"
---

# ChromeDriver and Chrome must match

ChromeDriver and Chrome are a pair: their major versions must match. You keep your installed Chrome and get the driver that fits it.

## Steps

1. Compare the majors:

   ```bash
   chromedriver --version
   "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --version
   ```

2. Homebrew's `chromedriver` and `chromedriver@beta` casks often lag behind auto-updated Chrome. Upgrade (`brew upgrade --cask chromedriver`) and compare again.
3. If no Homebrew version matches, get the driver from Google's [Chrome for Testing](https://googlechromelabs.github.io/chrome-for-testing/). This prints the newest driver version for your Chrome's major and its download link (use `mac-x64` or `linux64` on other machines):

   ```bash
   major=$("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --version | awk '{print $3}' | cut -d. -f1)
   curl -s https://googlechromelabs.github.io/chrome-for-testing/known-good-versions-with-downloads.json \
     | jq -r --arg m "$major" '[.versions[] | select(.version | startswith($m + ".")) | select(.downloads.chromedriver)] | last
       | .version, (.downloads.chromedriver[] | select(.platform == "mac-arm64") | .url)'
   ```

   Download that zip, unzip it into a folder of its own such as `~/.local/share/chromedriver/<version>/`, and use the `chromedriver` binary inside.
4. Start the matching driver on a port, run the test against it, then stop the driver:

   ```bash
   <path>/chromedriver --port=4444 &
   flutter drive -d web-server --browser-name=chrome --driver-port=4444 --headless --driver <driver.dart> --target <test.dart>
   ```

5. Pass the browser that matches the driver with `--chrome-binary "<path to Chrome binary>"`, especially in CI or when several Chrome versions are installed.

## Check

The browser session starts and the first test step runs.

## Pitfalls

- A version mismatch fails at the start with `session not created`.
- `CHROME_EXECUTABLE` alone doesn't choose WebDriver's browser; pass `--chrome-binary`.
- Stop old runs before starting a new one: leftover `flutter drive` or `flutter_tools.snapshot drive` processes and their Chrome windows (profiles named `flutter_tools_chrome_device`) interfere with the next run.
- In CI, use the runner's preinstalled browser and driver pair. Never replace only the driver with a `latest` version.
- Keep normal browser security so requests send their `Origin` header.
