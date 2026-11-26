---
name: codemagic-mac-app-store-signing
description: Sign and package native macOS and Mac Catalyst apps for the Mac App Store on Codemagic - the right provisioning profile type, reusing managed app signing, and importing the separate Mac Installer Distribution key for the .pkg without breaking the keychain. Use when a Mac App Store workflow on Codemagic fails at profiles, export or installer signing.
compatibility: Codemagic macOS builders with Xcode
metadata:
  verified: "2026-11"
  verified-with: "Codemagic CLI tools and signing docs; configuration and scripts checked locally, live signing not yet run"
---

# Mac App Store signing on Codemagic

The app is signed with the app-signing identity; the `.pkg` uploaded to Apple is signed separately with a **Mac Installer Distribution** identity. Customers still install normally from the Mac App Store.

## Steps

1. Use the right profile type: native macOS Store exports need `MAC_APP_STORE`, Mac Catalyst Store exports need `MAC_CATALYST_APP_STORE`. A matching bundle ID, certificate or successful archive doesn't make them interchangeable.
2. Reuse the managed app-signing identity when its certificate is in the profile. Apple Distribution works for macOS as well as iOS and visionOS.
3. Get the profile through the existing Apple integration (Fetch profiles, or a CLI download step selected with `xcode-project use-profiles --profile`), and verify the returned type before archiving.
4. Store the installer private key as a raw, unencrypted RSA PEM in a protected Secret variable (for example `MAC_INSTALLER_CERTIFICATE_PRIVATE_KEY`); the workflow fetches the matching certificate itself.
5. Import the installer identity into the existing managed keychain, allowing every tool that signs:

   ```bash
   keychain add-certificates --certificate <installer-path> --allow-app /usr/bin/codesign /usr/bin/productsign /usr/bin/productbuild
   ```

## Check

The workflow produces a `.pkg`, its publisher uploads it, and App Store Connect shows that exact version and build for macOS.

## Pitfalls

- The CLI's default allowed apps omit `productbuild`; add it while keeping the two defaults. Xcode's export signs the package directly with `productbuild`, while Codemagic's documented route builds an unsigned package and signs it with `productsign`.
- Don't export the app key or initialize a second keychain just to add installer signing. A managed identity doesn't create a `CERTIFICATE_PRIVATE_KEY` variable either.
- A new app needs its own Mac profile, not a new installer key. Reuse the team's installer identity.
- Never paste a CSR, `.cer`, PEM password, `.p12`, Base64 text or App Store Connect `.p8` key into the installer-key variable. A CSR alone can't recover a private key.
- Distribution outside the Mac App Store needs Developer ID signing and notarization instead; this setup doesn't cover it.
