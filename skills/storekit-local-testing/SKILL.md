---
name: storekit-local-testing
description: Test in-app purchases locally on iOS simulators with a StoreKit configuration file, including Flutter apps. Use when purchases fail or show no products in the simulator, or when automating purchase tests.
compatibility: macOS with Xcode, iOS simulators
metadata:
  verified: "2026-11"
  verified-with: "Xcode 27.2"
---

# Local StoreKit testing

## Steps

1. Create a `.storekit` configuration with the exact product identifiers and types your app uses.
2. In Xcode, select it in the scheme under Run → Options → StoreKit Configuration.
3. Choose your simulator and launch the app from Xcode with that scheme.
4. For automated tests, use `SKTestSession` from a test target, and run tests that change its shared state one at a time.

## Check

The app lists your test products and a test purchase completes.

## Pitfalls

- `flutter run` doesn't activate the scheme's StoreKit configuration; launch through Xcode.
- A scheme that references the file doesn't prove it's active. Verify that products actually load.
