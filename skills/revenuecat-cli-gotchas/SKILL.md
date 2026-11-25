---
name: revenuecat-cli-gotchas
description: Avoid RevenueCat CLI (rc) and API v2 traps - cached auth status, fields that apps show omits, customer IDs that must not be URL-encoded, price commands that only change the Test Store, refunds of Google orders, and attaching store credentials through the App API. Use when managing RevenueCat projects, products, customers or store connections from the command line.
compatibility: RevenueCat CLI 0.1.6 and API v2
metadata:
  verified: "2026-11-07"
  verified-with: "RevenueCat CLI 0.1.6 with browser OAuth"
---

# RevenueCat CLI traps

## Steps

1. Check access with a live call, not just the cached status:

   ```bash
   rc auth status --json --no-input
   rc projects list --json --no-input
   ```

   The status shows a cached identity; only the project list proves access.
2. Pass `--project-id` explicitly to every command. Reading one project proves only that project.
3. For fields a command leaves out, call the API through the CLI, for example the Google credential flag that `apps show` omits:

   ```bash
   rc api GET /projects/<project-id>/apps/<app-id> --json --no-input
   ```

4. Attach store credentials through the App API when creating or updating an app: Apple `subscription_private_key`, `subscription_key_id`, `subscription_key_issuer` and the `app_store_connect_api_key*` fields; Google `play_service_account_credentials_json`. No dashboard upload is needed.

## Check

`rc projects list` returns your projects, and the `rc api` read shows the field you were looking for.

## Pitfalls

- `rc products prices set` changes **Test Store** prices only, never App Store or Play prices.
- The store-state plan/apply flow can upload a placeholder App Review screenshot. Check its effects before applying.
- Keep customer IDs exactly as returned, including `$` and `:`. URL-encoding them first returns a false "customer not found".
- The customer `search` parameter takes an email, customer or alias ID, or a store transaction ID, not an app version or a time. Timestamps are in milliseconds.
- CLI 0.1.6 `refund` rejects Google orders as non-Web Billing despite its help text. Refund in Google Play instead (`orders.refund` with `revoke=true`); RevenueCat can take up to 24 hours to notice.
- Browser OAuth acts with your account's permissions across every project, broader than a project-scoped secret key.
- If the OS keychain is unavailable, the CLI can fall back to secret fields in its profile file. Check for that without printing values, and fix the keychain instead of accepting plaintext tokens.
- After a create call, read the result back by name or ID before retrying, so you don't create duplicates.
