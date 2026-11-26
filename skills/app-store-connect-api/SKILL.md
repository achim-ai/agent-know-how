---
name: app-store-connect-api
description: Use App Store Connect API keys from scripts and agents - which key role can do what (App Manager, In-App Purchase, Admin-only analytics), signing ES256 tokens in memory, keys stored as raw PEM or Base64, subscription price updates that fail with ENTITY_ERROR.RELATIONSHIP.REQUIRED, sending TestFlight webhook test pings without the web UI, and sandbox purchase accounts. Use when automating App Store Connect metadata, purchases, prices, profiles or reports.
compatibility: App Store Connect API and App Store Server API
metadata:
  verified: "2026-11"
  verified-with: "App Store Connect API with App Manager, In-App Purchase and Admin keys, October–November 2026; webhook pings with an App Manager key"
---

# App Store Connect API keys

## Steps

1. Pick the key by job:

   | Key | Can do | Can't do |
   | --- | --- | --- |
   | App Manager (team key) | Apps, in-app purchases, subscription groups, store metadata and screenshots, certificates, devices, bundle IDs, development and store profiles | Analytics report requests (HTTP 403, Admin required); banking |
   | In-App Purchase key | App Store Server API in production and sandbox, such as notification history | Isn't read-only: it can also sign offers and extend renewals |
   | Admin | Creating `analyticsReportRequests` | Use it only for that, then revoke it; routine report downloads work with Sales and Reports or Finance |

2. Sign a short-lived ES256 JWT in memory with the key ID and the Issuer ID (a UUID). Read the private key once per operation and never write it to a file for a build tool.
3. Accept keys stored as raw PEM. Decode Base64 only when it yields the expected P-256 PKCS#8 key.
4. Check the HTTP status and empty bodies before decoding JSON.

## Check

A read such as `GET /v1/apps?limit=200` returns HTTP 200 with the key you plan to use.

## Pitfalls

- **Subscription prices:** `PATCH /v1/subscriptions/{id}` accepts inline price resources. Send only the new territory prices; existing ones are kept. Including existing price IDs without their price-point payload fails with `ENTITY_ERROR.RELATIONSHIP.REQUIRED`.
- Apple currently returns 175 territories; set `availableInNewTerritories=true` so new territories don't silently lack prices. Plan availability `UPFRONT` is the normal model; `MONTHLY` is a different commitment model.
- Every new app needs its own analytics report request (`ONGOING`), created once with an Admin key.
- **Sandbox purchases:** create a Sandbox Apple Account in App Store Connect and sign in on the test device under **Settings → Developer → Sandbox Apple Account**, never in the main Apple Account settings. Don't change its storefront to get other screenshot prices.
- **TestFlight webhook test ping:** you don't need the web UI's Test button. List the app's webhooks with `GET /v1/apps/{app_id}/webhooks` (find the app with `GET /v1/apps?filter[bundleId]=<bundle-id>`), then send `POST /v1/webhookPings` with `{"data":{"type":"webhookPings","relationships":{"webhook":{"data":{"type":"webhooks","id":"<webhook-id>"}}}}}`. HTTP 201 means Apple queued a signed `webhookPingCreated` delivery to that URL; check your receiver's logs for it. An App Manager key is enough.
- Credential checks prove access, not that purchases or releases work.
