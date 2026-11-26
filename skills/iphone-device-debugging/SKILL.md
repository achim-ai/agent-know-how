---
name: iphone-device-debugging
description: Build, install and launch debug builds on a real iPhone from the command line - matching development profiles for every app and extension, explicit profiles instead of wildcard ones, keeping personal signing out of public repositories, devicectl installs that keep app data, and Flutter projects built directly in Xcode. Use when a device debug build fails to sign or install, or when running apps on your own iPhone.
compatibility: macOS with Xcode and a registered iPhone
metadata:
  verified: "2026-10"
  verified-with: "Xcode on macOS, 18 Swift and Flutter apps signed and built for one iPhone"
---

# Debug builds on your iPhone

## Steps

1. Every app **and** every embedded extension needs its own development profile for its exact bundle ID, even when they share one certificate and device. The profile must keep the App ID's capabilities, such as App Groups or App Attest.
2. If automatic signing picks an old wildcard profile without those capabilities, select explicit matching profiles instead.
3. Build for the device:

   ```bash
   xcodebuild -workspace <App>.xcworkspace -scheme <Scheme> -configuration Debug -destination 'id=<device-udid>' -derivedDataPath <dir> build
   ```

4. Install without uninstalling, so the app's data stays, then launch:

   ```bash
   xcrun devicectl device install app --device <device-udid> <dir>/Build/Products/Debug-iphoneos/<App>.app
   xcrun devicectl device process launch --device <device-udid> <bundle-id>
   ```

## Check

The app launches on the phone with its previous data intact.

## Pitfalls

- To find a usable development identity, match the certificate's **team** field. Searching the certificate's display name for the team ID can miss a valid identity.
- In a public repository, keep your team, profiles and device out of tracked files. Put them in a private `.xcconfig` outside the repository and pass it with `xcodebuild -xcconfig <file>`.
- Flutter apps built directly in Xcode can fail to find a generated Swift package link. Regenerate it with `flutter pub get --offline --enforce-lockfile`; never hand-edit generated package manifests.
- Two projects that share a bundle ID replace each other on the device.
- If an automation tool stops listing the phone while `devicectl` still installs and launches, that's a limit of the tool, not missing signing or a locked device.
- A debugger connection isn't proof of attachment; check that the process shows its executable modules.
- Profiles installed for Xcode live in `~/Library/Developer/Xcode/UserData/Provisioning Profiles/`.
