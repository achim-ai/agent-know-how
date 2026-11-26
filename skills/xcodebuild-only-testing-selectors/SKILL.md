---
name: xcodebuild-only-testing-selectors
description: Run exactly the Xcode tests you mean with -only-testing, without silently running zero tests or hitting the wrong device. Use when running focused XCTest or Swift Testing cases from the command line.
compatibility: macOS with Xcode
metadata:
  verified: "2026-11"
  verified-with: "Xcode 27.2"
---

# Focused xcodebuild test runs

A hand-typed selector that doesn't match can exit 0 with zero tests run.

## Steps

1. Get the destination ID from Xcode itself:

   ```bash
   xcodebuild -project <App>.xcodeproj -scheme <Scheme> -showdestinations
   ```

2. List the real test identifiers. Enumeration must use `test` or `test-without-building`:

   ```bash
   xcodebuild test-without-building -project <App>.xcodeproj -scheme <Scheme> -destination 'id=<udid>' -enumerate-tests -test-enumeration-format json -test-enumeration-output-path -
   ```

3. Copy identifiers exactly, including `()` and parameter labels such as `(value:)` for Swift Testing.
4. Run them (add `-enableCodeCoverage YES` if you need coverage):

   ```bash
   xcodebuild test -project <App>.xcodeproj -scheme <Scheme> -destination 'id=<udid>' -parallel-testing-enabled NO -only-testing:'<Target>/<Suite>/<test>()'
   ```

## Check

The result summary shows the number of tests you selected, not zero (see `xcresult-pass-check`).

## Pitfalls

- Quote the whole `-destination` value. An unquoted `platform=iOS Simulator,...` can select a physical device; prefer `id=<udid>`. Don't combine `-destination` with `-arch`.
- `-parallelizeTargets` and `-retry-tests-on-failure` take no value.
- Bare `-enumerate-tests` with no test action does a normal build that can strip the test plug-in.
- Enumeration can install and launch the test runner, so don't run it while another run uses that simulator. After `test-without-building`, add no further action to the same call.
- After changing source or tests, run `build-for-testing` again before `test-without-building`. If a shared DerivedData folder still serves old UI test code, use an isolated `-derivedDataPath`.
- When Xcode's destination picker hides simulators that `-showdestinations` lists, it's Xcode's UI state; use the ID from the command line.
