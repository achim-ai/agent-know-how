---
name: xcuitest-runner-stalls
description: Fix Xcode UI test runs that hang, get killed or fail to install - LLDB StoreError crashes, "waiting for workers to materialize", IXErrorDomain promise errors and SWBBuildService stalls. Use when xcodebuild test hangs or the UI test runner dies without a test failure.
compatibility: macOS with Xcode, iOS simulators
metadata:
  verified: "2026-11"
  verified-with: "Xcode 27.2"
---

# UI test runs that hang or die

## Steps

Match the symptom:

- **LLDB `DebuggerLLDB.DebuggerVersionStore.StoreError` keeps killing the runner:** turn off **Debug executable** in the shared scheme's Test action, then require a final test count above zero.
- **Stuck at `waiting for workers to materialize`** with enough free disk: stop the run, shut down and boot only that simulator, then run `xcodebuild test-without-building`. If it repeats, run the same test bundle on a fresh simulator.
- **Install errors or stalls after earlier attempts:** do one clean retry: fresh DerivedData, `build-for-testing` with normal signing, then `test-without-building` on one dedicated simulator.
- **First install on a just-booted simulator fails with `IXErrorDomain` code 3 (`Failed to locate promise`):** rerun once.
- **`xcodebuild` stalls with `SWBBuildService` leaving `clang -v -E -dM` blocked in `write`:** rerun with stdout and stderr redirected to a log file.
- **Sandboxed `pgrep` says `sysmond service not found`:** rerun it outside the sandbox. Exit 1 then means no runner is running.

## Check

The run reaches its final test summary and exits with a real result.

## Pitfalls

- Don't set `CODE_SIGNING_ALLOWED=NO` for apps with entitlements, Keychain use or extensions: it causes `IXErrorDomain` install errors or the `waiting for workers` stall.
- Run one UI test target per `xcodebuild` call, with parallel destinations off, and make sure no earlier runner is still alive before starting another.
- A silent `xcodebuild` isn't necessarily hung; wait for its exit code.
- After a test assertion fails, let the run finish instead of killing it, so the result bundle is complete.
