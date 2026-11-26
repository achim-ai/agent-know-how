---
name: ssh-commit-signature-verify
description: Cryptographically verify an SSH-signed Git commit against a known public key, without setting up Git's allowed-signers file. Use when git log shows signature status N or an allowedSignersFile error, or before pushing commits that must be signed.
compatibility: Git with SSH commit signing, ssh-keygen, Python 3
metadata:
  verified: "2026-11"
  verified-with: "macOS 27.2.1, Git with gpg.format ssh"
---

# Verify SSH commit signatures

Without `gpg.ssh.allowedSignersFile`, `git log --format=%G?` prints `N` and the error `gpg.ssh.allowedSignersFile needs to be configured`, even for a correctly signed commit. A `gpgsig` header alone doesn't prove the signature is valid either.

## Steps

Run the bundled script with the repository, the commit and the signer's public key:

```bash
bash scripts/verify-ssh-commit.sh <repo-path> <commit> ~/.ssh/<key>.pub
```

It splits the commit into signed data and signature and checks them with `ssh-keygen -Y verify`.

## Check

The output says `Good "git" signature for signer` and the exit code is 0.

## Pitfalls

- Only for conventional SSH-signed commits; not for OpenPGP or `gpgsig-sha256` signatures.
- A failing allowed-signers setup doesn't mean the signature is bad. Verify directly before concluding anything.
