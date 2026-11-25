---
name: xcuitest-gotchas
description: Avoid common XCUITest traps - launch versus activate, deep links that relaunch the app, text editing that silently does nothing, query limits and element roles. Use when writing or debugging iOS or macOS UI tests.
compatibility: Xcode UI tests
metadata:
  verified: "2026-11"
  verified-with: "Xcode 27.2"
---

# XCUITest traps

## Steps

- **Launch versus activate:** `XCUIApplication.launch()` restarts a running app; `activate()` brings it forward and may launch it if it isn't running.
- **Deep links into a running app:** use `XCUIDevice.shared.system.open(url)`. `XCUIApplication.open(url)` relaunches the app. Keep cold-launch tests separate.
- **Replacing text:** synthesized Command-A or delete key events prove nothing. Make sure the field has focus, long-press it, tap the native **Select All**, type, then assert the field's value.
- **Queries:** string subscripts are limited to 128 characters. Query by the element's real role (`activityIndicators` for spinners, `progressIndicators` for progress bars, `scrollViews` for scroll containers); `otherElements` doesn't find everything.
- **Concurrency:** mark UI test classes `@MainActor` before the first compile.

## Check

The test fails when the behavior is broken and passes when it works. Check both before trusting it.

## Pitfalls

- Don't add accessibility properties to production code only so tests can find something.
- On macOS, control the app through its `NSRunningApplication`, never through a bundle-identifier-only proxy when several processes share the identifier.
