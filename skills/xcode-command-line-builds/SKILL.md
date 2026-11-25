---
name: xcode-command-line-builds
description: Fix common xcodebuild and SwiftPM failures in agent sandboxes and after Xcode updates - license exit 69, unwritable Clang module cache, sandbox_apply errors, missing swift-format or xccov. Use when Swift or Xcode builds fail from an agent's shell but work in Xcode.
compatibility: macOS with Xcode
metadata:
  verified: "2026-11"
  verified-with: "Xcode 27.2, Swift 6.3"
---

# Xcode and SwiftPM builds from an agent shell

## Steps

1. After any Xcode install or update, run `xcodebuild -license check`. Exit 69 means the license isn't accepted: someone with admin rights runs `sudo xcodebuild -license accept`.
2. Run the first build with fresh DerivedData outside the sandbox: it must download packages and reach CoreSimulatorService.
3. Reuse one `-clonedSourcePackagesDirPath <dir>` for every build and test call so packages aren't fetched again.
4. Give every `xcodebuild` call exactly one action (`build`, `build-for-testing`, `test-without-building` …) and its own `-derivedDataPath` and `-resultBundlePath`. Separate repositories can then build and test at the same time.
5. If `swift test` fails on an unwritable Clang `ModuleCache` and then `sandbox-exec: sandbox_apply: Operation not permitted`, rerun outside the sandbox with the caches in a temporary folder:

   ```bash
   CLANG_MODULE_CACHE_PATH=/private/tmp/<task>-cache swift test --scratch-path /private/tmp/<task>-build
   ```

   For direct `swift` or `swiftc`, pass `-module-cache-path /private/tmp/<task>-cache` (or set `SWIFT_MODULECACHE_PATH` and `CLANG_MODULE_CACHE_PATH`) from the first call. If a macro plugin then reports a malformed response together with the sandbox error, also add `-Xfrontend -disable-sandbox`.

## Check

The build or test command finishes with exit 0.

## Pitfalls

- `error opening ~/.cache/clang/ModuleCache` means the module cache redirect from step 5 was missing on that call.
- `command not found: swift-format`: use `xcrun swift-format` (add `--recursive` for folders).
- `xccov` not on `PATH`: use `xcrun xccov` or `/Applications/Xcode.app/Contents/Developer/usr/bin/xccov`.
- SwiftPM coverage: `swift test --show-codecov-path` prints the exported JSON; pass the `default.profdata` next to it to `llvm-cov -instr-profile` together with the exact test binary.
- On GitHub-hosted macOS runners, use an Xcode whose image has a compatible simulator runtime and target a resolved simulator UDID, never a name with `OS:latest`.
