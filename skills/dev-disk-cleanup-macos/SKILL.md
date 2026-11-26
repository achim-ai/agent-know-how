---
name: dev-disk-cleanup-macos
description: Free disk space on a Mac used for iOS, Android and Flutter development and testing - find the large rebuildable folders (DerivedData, test results, simulators, emulators, build output, Gradle, FVM, Homebrew, editor caches, Docker), delete them safely and measure the real gain. Use when the disk is low, builds fail for space, or after heavy simulator or emulator test runs.
compatibility: macOS with Xcode; Android SDK, Flutter, Gradle, FVM, Homebrew and Docker where installed
metadata:
  verified: "2026-11"
  verified-with: "macOS 27.2.1, Xcode 27.2"
---

# Disk cleanup after development and testing

A single test session left up to 35 GB behind, mostly simulators, emulators and build output. Everything below is rebuildable; delete only what no running build or test uses.

## Steps

1. Measure free space the way Finder does (purgeable space included). `df` reports less:

   ```bash
   swift -e 'import Foundation; print(try URL(fileURLWithPath: "/").resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage!)'
   ```

2. Simulators: delete devices you created for tests (`xcrun simctl delete <udid>`) and ones whose runtime is gone (`xcrun simctl delete unavailable`). Check `xcrun simctl list devices` first, and also any private device sets you created with `--set`.
3. Xcode: delete inactive `~/Library/Developer/Xcode/DerivedData/<Project>-*` folders (each holds `Build`, `Index.noindex` and `Logs`; the shared `ModuleCache.noindex` next to them rebuilds too), custom `-derivedDataPath` folders (often under `/private/tmp`), and `.xcresult` bundles once you saved what you need from them. For an Xcode beta you no longer use, remove its app and the runtimes and simulators only it used, but keep the shared components Xcode installs on first launch.
4. Android: delete emulators you created with `avdmanager delete avd -n <name>` (in the SDK's `cmdline-tools/latest/bin`).
5. Flutter: run `flutter clean` in projects you aren't working on (removes `build/` and `.dart_tool/flutter_build/`). With FVM, `fvm list` shows installed SDKs and `fvm cleanup` suggests removals; remove versions no project's `.fvmrc` uses with `fvm remove <version>`.
6. Gradle: under `~/.gradle/caches/` and `~/.gradle/wrapper/dists/`, remove versioned folders for Gradle versions no project's wrapper uses, while no Gradle daemon runs. Remove an `-all` distribution once no wrapper references it and the matching `-bin` one is installed.
7. Homebrew: `brew cleanup --dry-run`, then `brew cleanup` removes old versions and downloads.
8. Editors: JetBrains and Android Studio keep caches for old versions in `~/Library/Caches/JetBrains/<Product><version>`; delete those of uninstalled versions but keep any `LocalHistory` folder inside. Toolbox keeps installer `.dmg` files in `~/Library/Caches/JetBrains/Toolbox/download/`.
9. Docker: check `docker system df`. Remove containers before their images; remove a volume only if its data is disposable.
10. Agent scratch: finished tasks leave folders under `/private/tmp`, including agent scratchpads such as `/private/tmp/claude-<uid>/`. Delete only those of tasks that are done.
11. Measure again with step 1.

## Check

The step 1 number went up by roughly what you deleted.

## Pitfalls

- Keep SDKs, simulator runtimes, Android system images and shared download caches (Pub cache, Xcode `SourcePackages`, SwiftPM caches, Gradle `modules-2`): deleting them only forces large downloads.
- A folder named `build`, `cache` or `tmp` can be real source, and a `.git` inside build output can be a copy. Look inside before deleting; never delete uncommitted work.
- Files still open in a running process free nothing until it exits.
- `docker system df` and image sizes are logical sizes of shared layers: don't add them up, and measure `Docker.raw` separately. It doesn't shrink right away after Docker cleanup.
- Docker Desktop's own app caches (HTTP, code and GPU caches) are separate from images and the VM. Delete them only while Docker Desktop is quit, and keep its settings, login data and `Docker.raw`.
- Deleted simulators can leave data-only folders without `device.plist` in `~/Library/Developer/CoreSimulator/Devices/`. Measure them separately; no device set lists them.
- Emulators started with a custom `ANDROID_AVD_HOME` don't appear in the default list. Check running emulator processes for their `.avd` path.
- Local Time Machine snapshots (`tmutil listlocalsnapshots /`) count as purgeable; macOS removes them when space runs low.
- When free space keeps falling, also check the swap files in `/System/Volumes/VM`. Never delete them.
- Install simulator runtimes in Xcode's Settings → Components. `xcodebuild -downloadPlatform` left extra runtimes marked "Unusable – Cryptex Mount Preferred"; `xcrun simctl runtime list` shows them and `xcrun simctl runtime delete <id>` removes them.
