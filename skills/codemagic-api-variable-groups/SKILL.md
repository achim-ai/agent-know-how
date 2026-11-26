---
name: codemagic-api-variable-groups
description: Create and fill Codemagic environment variable groups from a script or agent with the REST API instead of the web UI - create an app's group, add plain and secure variables without printing secrets, and read them back. Use when a Codemagic workflow needs new or changed environment variables, or a build fails because a variable group is missing.
compatibility: Codemagic REST API v3
metadata:
  verified: "2026-11"
  verified-with: "Codemagic API v3 with a personal API token, macOS 27.2, Python 3.14"
---

# Codemagic variable groups through the API

A personal Codemagic API token can create an app's variable groups and their values, so no one has to copy values into the web UI.

## Steps

1. Use the v3 server `https://codemagic.io` with the token in the `x-auth-token` header. The route list is in `https://codemagic.io/api/v3/schema/openapi.json`.
2. Find the app ID (legacy list: `GET https://api.codemagic.io/apps`, field `_id`), then list its groups: `GET /api/v3/apps/<app-id>/variable-groups` returns `{"data":[{"id","name"}]}`.
3. Create a missing group: `POST /api/v3/apps/<app-id>/variable-groups` with `{"name":"<group>"}` (HTTP 201). Read its ID from the list in step 2.
4. Add variables in bulk: `POST /api/v3/variable-groups/<group-id>/variables` with `{"secure":false,"variables":[{"name":"<NAME>","value":"<value>"}]}`. Send secrets in a separate call with `"secure":true`.
5. Read secrets inside your script (for example from the macOS Keychain) and put them only in the request body, never in command arguments or output.

## Check

`GET /api/v3/variable-groups/<group-id>/variables` lists every name with its `secure` flag; secure values aren't returned.

## Pitfalls

- The workflow's `environment.groups` names must match the group name exactly; a group that only exists in the YAML gives the build no variables.
- Secure values can't be read back. Keep their source if you'll need them again, or plan to replace them.
- Personal accounts have app-level groups, not team-level ones; check which scope the workflow's app uses before creating a group.
