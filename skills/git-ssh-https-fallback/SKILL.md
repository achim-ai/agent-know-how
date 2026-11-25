---
name: git-ssh-https-fallback
description: Keep working with GitHub when SSH Git transport fails (for example "Connection closed" on port 22 during an incident) by switching one command to HTTPS with the GitHub CLI's credential helper, without changing your Git config. Use when git fetch, pull or push over SSH fails while the GitHub API still works.
compatibility: Git with the GitHub CLI (gh) logged in
metadata:
  verified: "2026-11-04"
  verified-with: "git and gh 2.101 on macOS"
---

# HTTPS fallback when GitHub SSH fails

## Steps

1. Check SSH authentication without prompts:

   ```bash
   ssh -oBatchMode=yes -oConnectTimeout=10 -oStrictHostKeyChecking=yes -T git@github.com
   ```

   Success prints GitHub's greeting and exits **1**, because GitHub provides no shell.
2. If SSH fails but `gh api user` works, run the one Git command over HTTPS with the GitHub CLI as credential helper, for this command only:

   ```bash
   git -c credential.helper= -c 'credential.helper=!gh auth git-credential' ls-remote https://github.com/<owner>/<repo>.git refs/heads/main
   ```

3. Before a real push, check the exact target: `git ls-remote` for the branch, then `git push --dry-run`.

## Check

`git ls-remote` over HTTPS returns the branch's commit.

## Pitfalls

- The empty `credential.helper=` first clears other helpers, so the GitHub CLI's login is the one used.
- Don't rewrite the remote URL or global Git config for a temporary outage; check [GitHub status](https://www.githubstatus.com) for Git Operations incidents.
- Exit code 1 from `ssh -T` isn't a failure; read the greeting.
