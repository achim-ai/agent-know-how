---
name: xcresult-pass-check
description: Decide reliably whether an Xcode test result bundle (.xcresult) passed, failed or is incomplete, using xcresulttool. Use before reporting results from xcodebuild test runs, or before deleting old result bundles.
compatibility: macOS with Xcode
metadata:
  verified: "2026-11"
  verified-with: "Xcode 27.2"
---

# Did the test run pass?

Folder names, a wrapper's exit code or an old build log don't prove a pass. Read the bundle itself.

## Steps

1. Read the summary first, on its own:

   ```bash
   xcrun xcresulttool get test-results summary --path <bundle>.xcresult
   ```

2. Count the run as passed only when the top level shows `"result" : "Passed"`, `"failedTests" : 0` and a `"totalTestCount"` above 0.
3. Run any further queries on the same bundle one at a time, after the summary. For failures, read every failure message, not only the first.
4. Before calling a UI test run free of warnings, check its runtime-warning entries and the full log.

## Check

The three fields in step 2 match. Anything else is failed or incomplete. Keep failed, incomplete and build-only bundles apart from passed ones.

## Pitfalls

- A bundle without `Info.plist` is incomplete: the run didn't finish.
- On `TestReport` or `database.sqlite3` errors, retry the same read once, serially (outside a sandbox if you're in one).
- Don't use `xcresulttool` to rescue a run that timed out; rerun it.
- `No space left on device` produces broken bundles. Check free space before long runs.
