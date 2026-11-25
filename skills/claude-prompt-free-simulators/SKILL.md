---
name: claude-prompt-free-simulators
description: Create, boot, test and screenshot iOS, watchOS and visionOS simulators from Claude Code in the Claude desktop app without the device-access prompt, so auto mode keeps running unattended. Use when an agent boots simulators, runs XCUITests or takes simulator screenshots in the Claude desktop app.
compatibility: Claude desktop app on macOS with Xcode
metadata:
  verified: "2026-11-25"
  verified-with: "macOS 27.2.1, Xcode 27.2, Claude Code 2.1.311 in the Claude desktop app"
---

# Simulators without device-access prompts

The Claude desktop app's simulator panel asks the user for access to every booted simulator they haven't approved, and the MCP simulator and Xcode tools show the same dialog. The panel only watches the default device set, so simulators in your own device set never prompt.

## Steps

1. Pick a runtime that matches Xcode's SDK: compare `xcrun --sdk iphonesimulator --show-sdk-build-version` with `xcrun simctl list runtimes -j`.
2. Create and boot the simulator in a private device set:

   ```bash
   mkdir -p /private/tmp/<task>-set
   xcrun simctl --set /private/tmp/<task>-set create "Test iPhone" "iPhone 17 Pro" <runtime-id>
   xcrun simctl --set /private/tmp/<task>-set boot <udid>
   xcrun simctl --set /private/tmp/<task>-set bootstatus <udid> -b
   ```

3. Use the same `--set` for `install`, `launch`, `ui <udid> appearance dark` and `io <udid> screenshot <file>.png`.
4. For XCUITest, pass the set to every `xcodebuild` call (`-showdestinations`, `test`, `test-without-building`):

   ```bash
   xcodebuild test -scheme <Scheme> -destination id=<udid> -DVTSimulatorSetLocation=/private/tmp/<task>-set
   ```

5. Clean up: `xcrun simctl --set /private/tmp/<task>-set delete all`, then remove the folder.

## Check

`xcrun simctl list devices booted` (the default set) does not list your simulator, and no dialog appeared.

## Pitfalls

- Use `xcrun simctl` and `xcodebuild` through the shell, not the MCP simulator or Xcode tools: those show the dialog.
- Don't open the Simulator app; everything above runs headless.
- `flutter drive` and `flutter run` only see the default set. Build the app separately (`flutter build ios --simulator --debug -d <any default-set simulator> -t <entry>.dart`), then install and launch it with `simctl --set`. To test it, use a temporary integration-test entry point that drives the app itself and writes a marker file into the app container's `tmp` folder (`xcrun simctl --set <set> get_app_container <udid> <bundle-id> data`) when a screen is ready.
- A sandboxed shell can hide installed runtimes. Retry outside the sandbox before calling a runtime missing.
- Install runtimes in Xcode's Settings → Components. `xcodebuild -downloadPlatform` left duplicate runtimes marked "Unusable – Cryptex Mount Preferred" that stopped simulator creation; deleting the duplicate with `xcrun simctl runtime delete <id>` fixed it.
