---
name: macos-keychain-cli
description: Store and read secrets in the macOS Keychain from the command line with the built-in security tool, without the secret appearing in shell history or arguments. Use when an agent or script needs a token or password saved for later use on a Mac, or when giving a user a terminal command to save a secret.
compatibility: macOS
metadata:
  verified: "2026-11"
  verified-with: "macOS 27.2"
---

# Keychain secrets from the terminal

## Steps

1. Check that the default keychain is the one you want (usually `login.keychain-db`):

   ```bash
   security default-keychain
   ```

2. Give the user this command with the exact account and service names. They run it and type the secret twice into hidden prompts, the same value both times, then report only success or the error:

   ```bash
   security add-generic-password -a "<account>" -s "<service>" -T "" -w
   ```

   Before handing it over, check in an interactive terminal that it reaches the hidden prompt, then cancel with Ctrl-C without typing a value.
3. To create a new random secret, give a separate generator command first, for example `openssl rand -base64 32`, then the save command above. The value then never appears in a command line or shell history.
4. Read the secret inside the process that needs it, once, and send it straight to its service:

   ```bash
   security find-generic-password -a "<account>" -s "<service>" -w
   ```

## Check

Step 4 returns the value without any error. Report only that it worked, never the value.

## Pitfalls

- Keep `-w` last and leave out a Keychain path argument; a path before `-w` breaks option parsing.
- `-T ""` trusts no app automatically, so later reads may ask the user for approval.
- Add `-U` only to update an existing item on purpose.
- Store each secret as its own item, and keep non-secret setup data in project docs. Save text credential files as raw text; use Base64 only for binary files.
- Never pass a secret or a file's contents as a command argument, such as `-w "$(cat token.txt)"`: arguments show up in the process list.
- Use the native `security` tool, not custom scripts that handle the secret, and never print the value into logs.
