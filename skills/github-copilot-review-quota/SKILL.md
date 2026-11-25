---
name: github-copilot-review-quota
description: Avoid unexpected GitHub Copilot code review quota use on pull requests. Use when setting up repositories, opening or pushing to pull requests, or when Copilot review credits disappear faster than expected.
compatibility: GitHub with Copilot code review
metadata:
  verified: "2026-11"
  verified-with: "GitHub, November 2026"
---

# Copilot review quota

Automatic Copilot code review consumes review quota on every review it starts, public repositories included. The review is charged to the pull request's author, not the repository owner.

## Steps

1. Check all three places that can turn on automatic review: the repository's rulesets, the organization's settings and the pull request author's personal Copilot settings.
2. Turn automatic review off where you don't want it, including its options for new pushes and drafts.
3. Request a review manually only when the change is finished and checks pass.

## Check

Open or update a test pull request: no Copilot review starts.

## Pitfalls

- A draft pull request alone doesn't prove automatic review is off.
- With review on new pushes enabled, every push can start another charged review.
