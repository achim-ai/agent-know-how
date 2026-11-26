---
name: codemagic-store-releases
description: Make Codemagic release workflows actually deliver apps to TestFlight and Google Play - guards against green builds with no app, artifact paths in nested apps, TestFlight beta submission, Android signing and the first manual Play upload, timeouts, DNS failures and the build API. Use when setting up or debugging Codemagic store-release workflows for Flutter or native apps.
compatibility: Codemagic YAML workflows (codemagic.yaml)
metadata:
  verified: "2026-11"
  verified-with: "Codemagic YAML schema and build API v3"
---

# Codemagic store releases

A green build doesn't prove delivery. A run that says **No artifacts were found** shipped nothing.

## Steps

1. Before publishing, fail the build if the expected `.ipa` or `.aab` is missing or empty, and for web, if `index.html` is missing.
2. In `publishing.scripts`, parse `CM_ARTIFACT_LINKS` and fail unless the expected app package is in it; logs, mapping files, symbols or `_artifacts.zip` alone don't count.
3. Write artifact paths from the repository root: `working_directory` changes where scripts run, not where artifacts resolve. Nested apps need explicit `$CM_BUILD_DIR/<app-folder>/build/...` paths.
4. Apple: use the built-in `app_store_connect` publisher with `submit_to_testflight: true` and your `beta_groups`; uploading alone doesn't reach testers.
5. Android: reference the shared signing identity in `environment.android_signing`; Codemagic injects `CM_KEYSTORE_PATH`, `CM_KEYSTORE_PASSWORD`, `CM_KEY_ALIAS` and `CM_KEY_PASSWORD`. Publish with `google_play` and a service-account JSON stored raw (not Base64) in a protected group.
6. The first Google Play upload must be manual: download the AAB from the build's **Artifacts** and upload it under **Testing → Internal testing → Create new release**. Then confirm the next build, with a higher version code, publishes automatically.
7. Limit each workflow with `max_build_duration`; there's no per-step or per-upload timeout.

## Check

The Publishing stage reports acceptance of the exact version and build, and that build is visible in TestFlight or the Play testing track.

## Pitfalls

- **Upload key:** Play registers an upload certificate per app. Upload the first AAB signed with the same key the CI uses; a wrong-key error lists expected and found fingerprints, and changing the service-account JSON can't fix it.
- **Apple processing:** after upload, Apple can take up to 15 minutes to show the build and up to 120 minutes overall. After an interrupted upload, check App Store Connect for that exact build before retrying; it may already be accepted. If the uploader reports success and errors, check there too.
- **DNS faults on the build machine** look like `Could not resolve host: github.com`, SwiftPM `Could not resolve package dependencies` or `cannot change to …`, `Failed host lookup` or Gradle `UnknownHostException`. Rerun the unchanged build; don't add retry steps.
- `flutter: fvm` reads only a `.fvmrc` at the repository root.
- A workflow condition that skips Dependabot builds still uses runner minutes; remove the automatic trigger instead. Workflows without `triggering` events run only manually; automatic builds also need the provider webhook.
- On the individual plan, environment groups are per application; global variables need a team plan.
- Keep step logs as artifacts (`$CM_BUILD_DIR/build/logs/*.log`) so failed builds still give you a downloadable `_artifacts.zip`. Artifacts are kept 30 days on personal accounts.
- Build API v3: `GET /api/v3/teams/{team_id}/builds`, `GET /api/v3/builds/{build_id}`, `GET /api/v3/builds/{build_id}/actions`, `POST /api/v3/apps/{app_id}/builds`, with the personal API token in `x-auth-token`. The "Codemagic API key" used for Shorebird's `SHOREBIRD_TOKEN` can't authenticate there.
