---
name: github-mark-notifications-done
description: Mark GitHub notification threads as Done (removed from the inbox), not just read, using the gh CLI. Use when cleaning up notifications for merged pull requests or CI failures that a later run fixed.
compatibility: GitHub CLI (gh) signed in
metadata:
  verified: "2026-11"
  verified-with: "gh on macOS 27.2.1"
---

# Mark GitHub notifications as Done

## Steps

1. List notifications, read ones included:

   ```bash
   gh api 'notifications?all=true' --paginate -q '.[] | [.id, .repository.full_name, .subject.type, .subject.title, .updated_at] | @tsv'
   ```

2. Mark one thread Done:

   ```bash
   gh api --method DELETE notifications/threads/<thread_id> -i | head -1
   ```

## Check

The response status is `204`, and the thread is gone from the inbox.

## Pitfalls

- `PATCH notifications/threads/<id>` (status `205`) only marks the thread read; it stays in the inbox.
- CI notifications often have no subject URL. Match them by repository, workflow name, branch and time.
- Only clear threads whose pull request is merged or whose failure a later successful run of the same workflow replaced.
