---
name: cloudkit-cktool
description: Export, validate and import CloudKit schemas with xcrun cktool, and read a specific private record through Apple's web services API without adding query indexes. Use when checking or changing a CloudKit container's schema from the command line, or debugging CloudKit sync data.
compatibility: macOS with Xcode (xcrun cktool) and a CloudKit container
metadata:
  verified: "2026-11-04"
  verified-with: "xcrun cktool and the CloudKit web services API"
---

# CloudKit schemas with cktool

## Steps

1. Export both environments' schemas:

   ```bash
   xcrun cktool export-schema --team-id <team-id> --container-id <iCloud.container.id> --environment development
   xcrun cktool export-schema --team-id <team-id> --container-id <iCloud.container.id> --environment production
   ```

2. `validate-schema` only validates. `import-schema --validate` validates **and imports** into Development. Deploy to Production in the CloudKit Console.
3. To read one private record, fetch it by record name instead of adding a query index:

   ```text
   GET https://api.icloud.apple.com/v1/database/containers/<container>/environments/PRODUCTION/databases/private/zones/_defaultZone/records/<record-name>
   X-Apple-CloudKit-User-Token: <user token>
   X-CK-CLIENT: cktooljs-1.3.2
   ```

   Use `DEVELOPMENT` for the development environment. The user token is the one `cktool` saved; Apple's cktool JS client sends the `X-CK-CLIENT` header shown.

## Check

The exported schema contains your record types, and the record read returns HTTP 200 or a clear 404.

## Pitfalls

- The web API uses uppercase `PRODUCTION` and `DEVELOPMENT`; `cktool` uses lowercase.
- A query on an unindexed field is rejected; reading by record name avoids that.
- HTTP 404 "Record not found" means that record doesn't exist for this account. It doesn't prove sync works or that storage is empty.
- Schema access doesn't grant record access.
- `cktool` keeps its user token in an Internet Password item labelled for the cktool user token. A keychain read that stalls before returning is a local limit, not an expired token.
- TestFlight can't use a schema that exists only in Development. When a distributed build fails on CloudKit, check the Production schema first.
