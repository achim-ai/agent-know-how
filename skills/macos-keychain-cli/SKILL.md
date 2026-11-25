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
4. Whole files (service-account JSON, `.p8` or PEM keys) don't fit the hidden prompt: it takes one line of at most 128 characters and cuts the rest. Create an empty item instead, then paste the complete file text into it in **Keychain Access → login → the item → Show password**, and click **Save Changes**:

   ```bash
   security add-generic-password -a "<account>" -s "<service>" -T "" -w ""
   ```

   Keychain keeps the text exactly, including line breaks. Use Base64 only for binary files such as `.jks`. Keep the original file until a read-back matches it.
5. Read the secret inside the process that needs it, once, and send it straight to its service:

   ```bash
   security find-generic-password -a "<account>" -s "<service>" -w
   ```

## Check

`security find-generic-password -a "<account>" -s "<service>"` (without `-w`) shows the item's label and names without the secret, and step 5 works inside the consuming process. Report only that it worked, never the value.

## Pitfalls

- Keep `-w` last and leave out a Keychain path argument; a path before `-w` breaks option parsing.
- `-T ""` trusts no app automatically, so later reads may ask the user for approval.
- Add `-U` only to update an existing item on purpose.
- Store each secret as its own item, and keep non-secret setup data in project docs.
- Never pass a secret or a file's contents as a command argument, such as `-w "$(cat token.txt)"`: arguments show up in the process list.
- Use the native `security` tool, not custom scripts that handle the secret, and never print the value into logs.
- `find-generic-password -w` can print a stored JSON or PEM text as one long unprefixed hexadecimal string. If the whole output is even-length hex, decode it once in memory, then check it's the expected JSON or key.
- In an agent sandbox, a lookup can fail with exit 44 (item not found) while the same lookup outside the sandbox succeeds. Exit 44 never proves the credential is gone.
- A read that waits for a Keychain approval dialog isn't a missing credential: wait for the user to click **Allow**, then retry the same read. Don't ask for the secret again.
- A Python Security.framework read can return `-25293` where the native `security` tool succeeds; that error doesn't mean the credential is invalid.
