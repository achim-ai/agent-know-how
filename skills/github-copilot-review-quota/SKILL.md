---
name: github-copilot-review-quota
description: Avoid unexpected GitHub Copilot code review quota use on pull requests, and request a single low-cost review on purpose. Use when setting up repositories, opening or pushing to pull requests, requesting a Copilot review, or when Copilot review credits disappear faster than expected.
compatibility: GitHub with Copilot code review
metadata:
  verified: "2026-11"
  verified-with: "GitHub, gh 2.101.0"
---

# Copilot review quota

Automatic Copilot code review consumes review quota on every review it starts, public repositories included. The review is charged to the pull request's author, not the repository owner.

## Steps

1. Check all three places that can turn on automatic review: the repository's rulesets, the organization's settings and the pull request author's personal settings at [github.com/settings/copilot/code_review](https://github.com/settings/copilot/code_review). No documented API shows the personal setting, so check it on that page.
2. Turn automatic review off where you don't want it, including its options for new pushes and drafts.
3. Request a review manually only when the change is finished and checks pass, and ask for Lite effort so it doesn't inherit a higher default:

   ```bash
   gh api --include --method POST "repos/<owner>/<repo>/pulls/<number>/copilot-code-review" -f review_effort=lite
   ```

   It answers HTTP 201 with a pending review request. The response doesn't echo the effort: when the review is done, check that its body says `Review effort: Lite` and that it reviewed the current head commit.

## Check

Open or update a test pull request: no Copilot review starts.

## Pitfalls

- A draft pull request alone doesn't prove automatic review is off.
- With review on new pushes enabled, every push can start another charged review.
- A review summary that recommends approval can still have the GitHub review state `COMMENTED`. Follow progress through the pull request's `reviews` and `reviewRequests`, and read every new comment.
