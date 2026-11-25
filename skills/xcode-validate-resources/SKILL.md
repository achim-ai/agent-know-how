---
name: xcode-validate-resources
description: Validate and sync Xcode project resources with the right tool - plists, entitlements, privacy manifests, schemes, asset catalogs and String Catalogs (xcstrings), and check a signed app's real entitlements. Use when editing Info.plist, entitlements, .xcscheme, Contents.json or Localizable.xcstrings files.
compatibility: macOS with Xcode
metadata:
  verified: "2026-11"
  verified-with: "Xcode 27.2"
---

# Validate Xcode resources

## Steps

1. Use the tool that fits the file:
   - plists, entitlements, privacy manifests: `plutil -lint <file>`
   - `.xcscheme`: `xmllint --noout <file>`
   - `Contents.json`: any JSON parser
   - `.xcstrings`: a JSON parser or `xcrun xcstringstool`
2. Sync a String Catalog from compiled strings:

   ```bash
   xcrun xcstringstool sync <Localizable.xcstrings> --stringsdata <file>.stringsdata
   ```

3. Check the entitlements inside a signed app:

   ```bash
   codesign -d --entitlements - --xml <App>.app
   ```

## Check

Each tool exits 0, and the signed app's entitlements contain what you expect.

## Pitfalls

- `xcstringstool sync` rejects positional `.stringsdata` files; use `--stringsdata`.
- Don't run `plutil` on schemes or String Catalogs.
- Use `--entitlements -`, not the older `--entitlements :-`.
- XcodeGen: set `INFOPLIST_FILE` and `CODE_SIGN_ENTITLEMENTS` in target settings, not `info.path` or `entitlements.path`; regenerating with those can erase metadata.
