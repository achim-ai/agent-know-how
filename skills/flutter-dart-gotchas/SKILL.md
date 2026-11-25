---
name: flutter-dart-gotchas
description: Avoid Flutter and Dart traps that waste debugging time - dart analyze passing with infos, awaiting void, scrollUntilVisible casts, hidden test counts, Drift final tables, CocoaPods after upgrades, Gradle -all distributions. Use when building, analyzing or testing Flutter and Dart projects.
compatibility: Flutter and Dart projects
metadata:
  verified: "2026-11"
  verified-with: "Flutter 3.47–3.50"
---

# Flutter and Dart traps

## Steps

- **Analysis:** run `dart analyze --fatal-infos`; the default exit code accepts infos.
- **`void main() async` in integration tests:** call it without `await`, then let the binding settle. Awaiting it fails with `This expression has type 'void' and can't be used.` The same applies to `rootBundle.evict`, which returns `void`.
- **`Future` main with native async setup in widget tests:** run `await tester.runAsync(app.main)` before pumping. Load large `loadString` assets with `tester.runAsync` too, and inject them.
- **`scrollUntilVisible`:** pass the scroll view's descendant `Scrollable`. Passing a `CustomScrollView` fails with a cast error. For controls that are already built, `ensureVisible` right before the tap is enough; then wait for a frame and check the target is hit-testable.
- **Counting test results** from `--machine` output: read visibility from `testDone.hidden`, not `testStart.hidden`. In JSON failure output, read both `error` and `print` events: the assertion detail can appear only in `print`.
- **Code generation:** `build_runner` no longer has `--delete-conflicting-outputs`. Compare the generated files before and after a run: a filtered run can delete sibling outputs.
- **Drift:** table classes must not be `final`; generated code then fails with `can't be extended outside of its library`.
- **After a Flutter or Dart upgrade** in apps with `ios/` or `macos/`: run `pod install --repo-update` in each and commit every `Podfile.lock`.
- **After switching branches:** run `pub get` before any `--no-pub` command, so package metadata matches the checkout.
- **Gradle:** use the `-bin.zip` wrapper distribution, not `-all.zip`. Keep the project's Gradle version and verify the wrapper JAR's checksum.
- **macOS builds without a development certificate:** check that the code compiles with `CODE_SIGNING_ALLOWED=NO`, keeping the entitlements, and verify signing separately.
- **Several connected devices:** pass an explicit `-d <device-id>` to `flutter run`, `test` and `drive`.

## Check

`dart analyze --fatal-infos` is clean and the affected tests pass.

## Pitfalls

- With FVM, `fvm spawn --help` can start an SDK install; read top-level `fvm --help` instead. Install an SDK with `fvm install <version> -s`.
- If FVM can't fetch its release list, or reports `Operation not permitted` on its cache, the agent sandbox is blocking it: rerun the same command with network and file access, or call `.fvm/flutter_sdk/bin/flutter` (or `bin/dart`) directly.
- `flutter run` doesn't activate a scheme's StoreKit configuration (see `storekit-local-testing`).
