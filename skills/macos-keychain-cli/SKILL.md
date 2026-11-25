---
name: macos-keychain-cli
description: Store and read secrets in the macOS Keychain from the command line with the built-in security tool, without the secret appearing in shell history or arguments. Use when an agent or script needs a token or password saved for later use on a Mac.
compatibility: macOS
metadata:
  verified: "2026-11"
  verified-with: "macOS 27.2"
---

# Keychain secrets from the terminal

## Steps

1. Save a secret. The user types it twice into hidden prompts:

   ```bash
   security add-generic-password -a "<account>" -s "<service>" -T "" -w
   ```

2. Read it inside the process that needs it:

   ```bash
   security find-generic-password -a "<account>" -s "<service>" -w
   ```

## Check

Step 2 returns the value without any error.

## Pitfalls

- Keep `-w` last and leave out a Keychain path argument; a path before `-w` breaks option parsing.
- `-T ""` trusts no app automatically, so later reads may ask the user for approval.
- Add `-U` only to update an existing item on purpose.
- Use the native `security` tool, not custom scripts that handle the secret, and never print the value into logs.
