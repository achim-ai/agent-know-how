---
name: macos-ui-tests-unattended
description: Run XCUITests and other UI automation on a Mac (macOS apps, Mac Catalyst, Designed for iPad) without hanging on an Automation Mode password prompt, a locked screen or sleep. Use when Mac UI tests hang, never launch, or wait for authentication.
compatibility: macOS with Xcode
metadata:
  verified: "2026-11-25"
  verified-with: "macOS 27.2.1, Xcode 27.2"
---

# Unattended Mac UI tests

Mac UI tests drive the real desktop. They hang or never start when Automation Mode needs a password, the screen is locked, or the Mac sleeps. They also fight anyone using the Mac at the same time.

## Steps

1. Once per Mac, as an administrator, allow Automation Mode without a password:

   ```bash
   sudo automationmodetool enable-automationmode-without-authentication
   ```

   `automationmodetool` with no arguments prints the current status. Without this step it says `This device requires user authentication to enable Automation Mode.`
2. Before each run, make sure the screen is unlocked. This prints `"CGSSessionScreenIsLocked"=Yes` when locked and nothing when unlocked:

   ```bash
   ioreg -n Root -d1 | grep -o '"CGSSessionScreenIsLocked"=[A-Za-z]*'
   ```

   If it's locked, check again every few seconds for a couple of minutes, and don't start until it's unlocked.

3. Make sure nobody is using the Mac. This prints the seconds since the last mouse or keyboard input; wait for at least 300:

   ```bash
   ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print int($NF/1000000000); exit}'
   ```

4. Keep the Mac awake for the run only:

   ```bash
   caffeinate -di xcodebuild test -scheme <Scheme> -destination 'platform=macOS'
   ```

## Check

Test cases start within a minute and no password dialog appears.

## Pitfalls

- On a locked screen XCTest doesn't launch and reports no error; it just waits.
- Without step 1, the test host waits for Automation Mode authentication at its first native interaction.
- After stopping a blocked run, check that the app process really exited; it can stay behind as a zombie.
- Where you can, drive screens your app draws itself through the app's own test hooks (for example Flutter's VM service) and keep XCUITest for native system panels. Only those need Automation Mode.
- **Flutter iOS apps on a Mac (Designed for iPad):** run the iOS test build on the Mac's Designed for iPad destination, drive the app and capture its frames through the VM service. That route needs no Automation Mode; only steps that open native panels (file pickers, share sheets, system settings) do.
- Check every screenshot for visible content: decode it and reject fully transparent, single-colour or truncated images. A bitmap capture of an `NSOpenPanel` content view came back fully transparent while the test still "passed".
- To rerun an iOS integration test quickly, reuse a prebuilt app with `flutter drive --use-application-binary <path to Runner.app>`.
- Changing Automation Mode is a security setting: ask the Mac's owner first.
