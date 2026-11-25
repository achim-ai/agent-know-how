---
name: storekit-local-testing
description: Test in-app purchases locally on iOS simulators with a StoreKit configuration file, including Flutter apps and RevenueCat. Use when purchases fail or show no products in the simulator, or when automating purchase tests.
compatibility: macOS with Xcode, iOS simulators
metadata:
  verified: "2026-11"
  verified-with: "Xcode 27.2"
---

# Local StoreKit testing

## Steps

1. Before assuming purchases can't be tested, look at the purchase SDK and its StoreKit version, the product identifiers, the scheme and any existing test configuration.
2. Create a `.storekit` configuration with the exact product identifiers and types your app uses.
3. In Xcode, select it in the scheme under Run → Options → StoreKit Configuration.
4. Choose your simulator and launch the app from Xcode with that scheme.
5. With RevenueCat, the products must also exist in its catalog, and its local receipt check may need the StoreKit public certificate exported from Xcode.
6. For automated tests, use `SKTestSession` from a test target, and run tests that change its shared state one at a time.

## Check

The app lists your test products, a test purchase completes through the real purchase button, the paid feature unlocks, and it stays unlocked after relaunching the app.

## Pitfalls

- `flutter run` doesn't activate the scheme's StoreKit configuration; launch through Xcode.
- A scheme that references the file doesn't prove it's active. Verify that products actually load.
- StoreKit 1, StoreKit 2, local Xcode testing and Apple's sandbox have different requirements; follow the docs of the SDK version you have installed.
- Don't fake the purchase or pre-fill entitlement caches: that tests nothing. A local test transaction only proves the test environment.
- Cancel unexpected Apple account or payment prompts.
