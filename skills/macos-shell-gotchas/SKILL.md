---
name: macos-shell-gotchas
description: Avoid shell and scripting traps on macOS - zsh special variables like status and path, the test alias, silent failures in pipelines, old system Ruby and Python. Use when writing shell commands or inline scripts for zsh, bash, Ruby or Python on a Mac.
compatibility: macOS (zsh default shell)
metadata:
  verified: "2026-11"
  verified-with: "macOS 27.2"
---

# macOS shell traps

## Steps

- **zsh variables:** never assign `status` (read-only in zsh) or `path` (tied to `PATH`, so assigning it breaks command lookup). Use names like `exit_code` and `route_path`.
- **Conditions in zsh:** use `[[ ... ]]`; plain `test` can resolve to a login-shell alias.
- **Fail loudly:** start multi-command checks with `set -euo pipefail` and never append `|| true`, so an early failure can't hide behind a later success.
- **System Ruby:** `filter_map` is missing (use `map.compact`); use `YAML.safe_load(File.read(path), aliases: true)` when `safe_load_file` is missing; `require "tmpdir"` before `Dir.tmpdir`.
- **System Python:** may lack `tomllib` (`ModuleNotFoundError` means your check never ran). Run inline Python with `-W error::SyntaxWarning` and raw strings for regex.
- **Sandbox errors:** `index.lock`, file-open or IPC permission errors in an agent sandbox mean: rerun the same command with more permission, don't change approach.

## Check

A command that should fail actually returns a non-zero exit code.

## Pitfalls

- A search that is expected to find nothing exits 1. Run it alone and check its status instead of chaining it.
