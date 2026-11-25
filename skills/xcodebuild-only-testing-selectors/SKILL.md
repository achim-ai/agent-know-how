---
name: xcodebuild-only-testing-selectors
description: Run exactly the Xcode tests you mean with -only-testing, without silently running zero tests or hitting the wrong device. Use when running focused XCTest or Swift Testing cases from the command line.
compatibility: macOS with Xcode
metadata:
  verified: "2026-11-25"
  verified-with: "Xcode 27.2"
---

# Focused xcodebuild test runs

A hand-typed selector that doesn't match can exit 0 with zero tests run.

## Steps

1. List the real test identifiers. Enumeration must use `test` or `test-without-building`:

   ```bash
   xcodebuild test-without-building -project <App>.xcodeproj -scheme <Scheme> -destination 'id=<udid>' -enumerate-tests -test-enumeration-format json -test-enumeration-output-path -
   ```

2. Copy identifiers exactly, including `()` and parameter labels such as `(value:)` for Swift Testing.
3. Run them:

   ```bash
   xcodebuild test -project <App>.xcodeproj -scheme <Scheme> -destination 'id=<udid>' -parallel-testing-enabled NO -only-testing:'<Target>/<Suite>/<test>()'
   ```

## Check

The result summary shows the number of tests you selected, not zero (see `xcresult-pass-check`).

## Pitfalls

- Quote the whole `-destination` value. An unquoted `platform=iOS Simulator,...` can select a physical device; prefer `id=<udid>`.
- Bare `-enumerate-tests` with no test action does a normal build that can strip the test plug-in.
- After changing source or tests, run `build-for-testing` again before `test-without-building`.
