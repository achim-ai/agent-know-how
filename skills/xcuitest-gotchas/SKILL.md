---
name: xcuitest-gotchas
description: Avoid common XCUITest traps - launch versus activate, deep links that relaunch the app, text editing that silently does nothing, query limits, element roles, stale queries, sheets and alerts, permissions and test state. Use when writing or debugging iOS or macOS UI tests.
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
- **Queries are live:** `firstMatch` and other queries look the element up again each time. After navigation or a transition, re-read its identity and position before using them.
- **SwiftUI combined elements:** query them by identifier or their combined label. An identifier on a container can override its children's.
- **Screens:** identify them by role and stable identifiers, not by localized titles. Wait for removed controls to disappear, and make sure the target isn't covered by a navigation bar, keyboard or toolbar before tapping.
- **Sheets and alerts:** wait for the presented container before querying its buttons, and after dismissing, wait until it is gone.
- **Permissions:** for tests of the first permission request, reset the app's authorization first, for example with `XCUIApplication().resetAuthorizationStatus(for:)`. Test the already-authorized path separately.
- **Concurrency:** mark UI test classes `@MainActor` before the first compile.

## Check

The test fails when the behavior is broken and passes when it works. Check both before trusting it.

## Pitfalls

- Don't add accessibility properties to production code only so tests can find something.
- On macOS, control the app through its `NSRunningApplication`, never through a bundle-identifier-only proxy when several processes share the identifier.
- An unsigned test runner may have no working Keychain. Inject an in-memory store at launch behind `#if DEBUG` instead of weakening production storage.
- Tests that write shared App Group defaults must remove their keys before and after each case.
