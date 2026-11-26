---
name: google-play-service-account-api
description: Set up and use Google Play service accounts for the Android Publisher API - least-privilege Play permissions for read-only reporting versus store management, the OAuth token flow, safe listing edits, track and build inspection, and which Console settings have no API. Use when automating Play listings, screenshots, products, refunds, reviews or release inspection.
compatibility: Google Play Console, Android Publisher API v3, Google Cloud service accounts
metadata:
  verified: "2026-11"
  verified-with: "Android Publisher API discovery revisions 20261105–20261116"
---

# Google Play service accounts and the Publisher API

## Steps

1. Use two service accounts with separate jobs:

   | Job | Play Console permissions |
   | --- | --- |
   | Reporting: reviews, ratings, crashes | **View app information and download bulk reports (read-only)** only |
   | Store management | That, plus **View financial data, orders, and cancellation survey responses**, **Manage orders and subscriptions**, **Manage store presence**, **Create, edit, and delete draft apps**, and per app **Manage policy declarations** for Data safety |

   **Create, edit, and delete draft apps** is needed to create products in apps that are still drafts.
2. Get a token: sign an RS256 assertion with `iss` = the service-account email, `scope` = `https://www.googleapis.com/auth/androidpublisher`, `aud` = `https://oauth2.googleapis.com/token`, and exchange it there with `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer`.
3. For a listing change: open an edit, read the complete listing, images, contacts and tracks, change only what you mean to, validate, then commit with `changesInReviewBehavior=ERROR_IF_IN_REVIEW`. Compare the result in a fresh edit, including image hashes.
4. Inspect builds without an edit: `GET …/applications/{package}/tracks/{track}/releases` and `GET …/applications/{package}/generatedApks/{versionCode}`.

## Check

A fresh edit shows exactly the intended text and image hashes, with everything else unchanged.

## Pitfalls

- `changesNotSentForReview=true` was rejected for apps whose production track is inactive; leave it out.
- Delete verification edits: DELETE returns 204, and a later GET returns 400 `FAILED_PRECONDITION` "This Edit has been deleted".
- No API for the app category, the privacy-policy URL, the dashboard setup checklist, track countries (`countryAvailability` is read-only) or email tester lists (`testers` holds Google Groups only). `tracks.update` can place an already uploaded version code on a track.
- HTTP 204 on product lists means "none", not an error. HTTP 404 "App Bundle version code could not be found" means the bundle is absent, not why its upload failed.
- A 403 on the developer `users.list` permission inventory only denies that read; it says nothing about other operations.
- `SERVICE_DISABLED` from Service Usage or Cloud Resource Manager doesn't mean missing roles or a broken purchase setup.
- Service-account display names can be edited; IDs and emails can't, so changing an identity means a new account and moving its grants.
- Refunds: `orders.refund` with `revoke=true` returns 204.
- Store each key as raw JSON. A sandboxed Keychain lookup returning "not found" doesn't mean the key was revoked; recheck outside the sandbox.
