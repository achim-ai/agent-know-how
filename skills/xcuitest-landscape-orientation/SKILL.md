---
name: xcuitest-landscape-orientation
description: Make XCUITests reliably run in landscape on iPhone and iPad simulators and prove the app really rotated. Use when a landscape UI test still shows the portrait layout or orientation assertions are flaky.
compatibility: Xcode UI tests on iOS and iPadOS simulators
metadata:
  verified: "2026-11"
  verified-with: "Xcode 27.2"
---

# Landscape XCUITests

## Steps

1. Before launch, set one landscape direction: `XCUIDevice.shared.orientation = .landscapeLeft`.
2. Launch the app.
3. After launch, set the opposite direction: `XCUIDevice.shared.orientation = .landscapeRight`.
4. Assert `XCUIDevice.shared.orientation`, the landscape layout and that key controls are hittable.

## Check

All three assertions in step 4 pass on the target device.

## Pitfalls

- Device pose, interface orientation and window size are separate facts. Check the one your test depends on.
- To know which simulator the test runs on, read `ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"]`.
- Verify the installed app's build SDK before device-specific layout tests.
