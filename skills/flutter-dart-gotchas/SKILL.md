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
- **`scrollUntilVisible`:** pass the scroll view's descendant `Scrollable`. Passing a `CustomScrollView` fails with a cast error.
- **Counting test results** from `--machine` output: read visibility from `testDone.hidden`, not `testStart.hidden`.
- **Drift:** table classes must not be `final`; generated code then fails with `can't be extended outside of its library`.
- **After a Flutter or Dart upgrade** in apps with `ios/` or `macos/`: run `pod install --repo-update` in each and commit every `Podfile.lock`.
- **Gradle:** use the `-bin.zip` wrapper distribution, not `-all.zip`.
- **macOS builds without a development certificate:** check that the code compiles with `CODE_SIGNING_ALLOWED=NO`, keeping the entitlements, and verify signing separately.

## Check

`dart analyze --fatal-infos` is clean and the affected tests pass.

## Pitfalls

- With FVM, `fvm spawn --help` can start an SDK install; read top-level `fvm --help` instead.
- `flutter run` doesn't activate a scheme's StoreKit configuration (see `storekit-local-testing`).
