---
name: codemagic-visionos-testflight-lookup
description: Diagnose native visionOS builds that upload fine from Codemagic but never get TestFlight notes, groups or beta review, because the publisher looks the build up as iOS. Use when a visionOS workflow's App Store Connect publishing step fails or stalls after a successful upload.
compatibility: Codemagic app_store_connect publisher, native visionOS apps
metadata:
  verified: "2026-10-24"
  verified-with: "Codemagic CLI tools source 3248a28, App Store Connect API"
---

# visionOS builds Codemagic can't find after upload

Codemagic's publisher uploads the native visionOS IPA, Apple accepts it, but the step that adds testing notes, groups and beta review never finds the build. In the public CLI source, every non-tvOS IPA is mapped to `IOS`, and the build lookup filters by that platform.

## Steps

1. Confirm Apple accepted the build: list builds with the App Store Connect API filtered by app, version, build number and `preReleaseVersion.platform`.
2. The same query returns nothing with `IOS` and finds the build with `VISION_OS`. That pattern confirms a lookup fault, not a rejected binary.
3. Check the build's beta state: an accepted build shows `READY_FOR_BETA_SUBMISSION` externally until it's submitted.

## Check

The `VISION_OS` query returns the exact version and build with processing state `VALID`.

## Pitfalls

- The YAML schema has no platform override for the `app_store_connect` publisher, so no YAML-only fix exists.
- Don't upload another binary to repair the lookup of a build Apple already accepted.
- Don't hide the failure by turning off beta submission, groups or notes. Either complete those steps for that build in App Store Connect, or wait for Codemagic to support native `VISION_OS` lookup.
