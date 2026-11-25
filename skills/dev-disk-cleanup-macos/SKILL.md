---
name: dev-disk-cleanup-macos
description: Free disk space on a Mac used for iOS, Android and Flutter development and testing - find the large rebuildable folders (DerivedData, test results, simulators, emulators, build output, Docker), delete them safely and measure the real gain. Use when the disk is low, builds fail for space, or after heavy simulator or emulator test runs.
compatibility: macOS with Xcode; Android SDK, Flutter and Docker where installed
metadata:
  verified: "2026-11-25"
  verified-with: "macOS 27.2.1, Xcode 27.2"
---

# Disk cleanup after development and testing

A single test session left up to 35 GB behind, mostly simulators, emulators and build output. Everything below is rebuildable; delete only what no running build or test uses.

## Steps

1. Measure free space the way Finder does (purgeable space included). `df` reports less:

   ```bash
   swift -e 'import Foundation; print(try URL(fileURLWithPath: "/").resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage!)'
   ```

2. Simulators: delete devices you created for tests (`xcrun simctl delete <udid>`) and ones whose runtime is gone (`xcrun simctl delete unavailable`). Check `xcrun simctl list devices` first.
3. Xcode: delete inactive `~/Library/Developer/Xcode/DerivedData/<Project>-*` folders, and `.xcresult` bundles once you saved what you need from them.
4. Android: delete emulators you created with `avdmanager delete avd -n <name>` (in the SDK's `cmdline-tools/latest/bin`).
5. Flutter: run `flutter clean` in projects you aren't working on (removes `build/` and `.dart_tool/flutter_build/`).
6. Docker: check `docker system df`. Remove containers before their images; remove a volume only if its data is disposable.
7. Measure again with step 1.

## Check

The step 1 number went up by roughly what you deleted.

## Pitfalls

- Keep SDKs, simulator runtimes, Android system images and shared download caches (Pub cache, SwiftPM caches, Gradle `modules-2`): deleting them only forces large downloads.
- A folder named `build`, `cache` or `tmp` can be real source. Look inside before deleting; never delete uncommitted work.
- Files still open in a running process free nothing until it exits.
- `Docker.raw` doesn't shrink right away after Docker cleanup.
- Local Time Machine snapshots (`tmutil listlocalsnapshots /`) count as purgeable; macOS removes them when space runs low.
- Install simulator runtimes in Xcode's Settings → Components. `xcodebuild -downloadPlatform` left extra runtimes marked "Unusable – Cryptex Mount Preferred"; `xcrun simctl runtime list` shows them and `xcrun simctl runtime delete <id>` removes them.
