---
name: google-play-test-purchases
description: Test Google Play in-app purchases and subscriptions without real charges - license tester accounts, signing a dedicated account into an emulator, which account Billing uses, sideloaded debug builds, and why BILLING_UNAVAILABLE appears. Use when testing Android purchases on emulators or devices, or with RevenueCat.
compatibility: Google Play Billing on Android emulators with Google Play images and on devices
metadata:
  verified: "2026-11-12"
  verified-with: "Tester sign-in on an Android 17 (API 37) Google Play emulator; billing behavior from Google's and RevenueCat's testing docs"
---

# Google Play test purchases

## Steps

1. Use a dedicated Google Account with no personal data and no developer role. Add it in Play Console under **Settings → License testing → Email lists**.
2. Sign that account into Google Play on the device or emulator. A service account can never sign a device in. On an emulator, use a Google Play system image.
3. Install the app either from a test track (the account must be in that track's tester list and opted in) or as a sideloaded debug build whose package name matches the Play app.
4. In the purchase dialog, check the account email, choose **Test card, always approves** and confirm the test-purchase notice.

## Check

The purchase dialog shows the tester account and the test-purchase notice, and the purchase completes without a real charge.

## Pitfalls

- Without a Google account on the device, Billing reports `BILLING_UNAVAILABLE` (RevenueCat: `PurchaseNotAllowedError`), even with Play Store and Play Services installed.
- With several accounts on the device, Billing uses the account that installed the app, or the first account. Check the email in the purchase dialog. Find the device's account under Google Play → profile picture at the top right.
- Ordinary accounts in test tracks can be charged for real; only license testers get test cards.
- Never change the tester's country or payment profile to hide unavailable products; offer products in all regions instead.
- Signing in on an API 35 emulator failed with Google's generic error before the email step, while API 37 worked. If Google opens a passkey chooser, cancel it and choose **Try another way → Enter your password**.
- Each new emulator needs its own sign-in. To let a person complete a verification step on a headless emulator (`-no-window`), show it with `scrcpy --serial=<serial> --no-audio --no-clipboard-autosync`.
- Keep screenshots, recordings and UI dumps off while the password field may be on screen; one unredacted UI dump exposed a typed password. Don't type secrets with a tool that logs its input.
