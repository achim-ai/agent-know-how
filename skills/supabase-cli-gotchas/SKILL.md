---
name: supabase-cli-gotchas
description: Avoid Supabase CLI traps - inconsistent output flags, db query argument rules, secrets printed by api-keys and status, local Edge Function secrets, and functions deploy --prune deleting functions. Use when running supabase CLI commands for databases, migrations or Edge Functions.
compatibility: Supabase CLI 2.110–2.117
metadata:
  verified: "2026-11"
  verified-with: "Supabase CLI 2.110.0 and 2.117.0"
---

# Supabase CLI traps

## Steps

- **Output flags differ:** `projects list` and `functions list` take `--output pretty`; `db query` takes `--output table`.
- **`db query`:** inline SQL only as the single positional argument (there is no `--sql`). SQL that starts with a `--` comment needs `--file`, whose path is relative to `--workdir`. Several statements in one call can be rejected: split them.
- **`test db`:** test paths are relative to the shell's current folder, not `--workdir`.
- **`functions list`** takes its project from `--workdir` and rejects `--linked`.
- **Local Edge Function secrets:** pass them with `functions serve --env-file <file>`; your shell environment doesn't reach the runtime. Use `PUBLISHABLE_KEY` from `supabase status --output env` for local calls, not the legacy `ANON_KEY`.
- **Multi-project repos:** pass the exact `--workdir` on every command.
- **Restricted sandboxes:** prefix commands with `SUPABASE_TELEMETRY_DISABLED=1`.

## Check

Commands return their data, and `supabase stop --workdir <dir>` leaves no project containers running.

## Pitfalls

- `projects api-keys` prints service-role keys even without `--reveal`, and `start` and `status` print local secrets. Don't run them into logs.
- `functions deploy --prune` deletes every function you didn't name. Never combine it with a subset; for a full sync, name none and add `--yes`.
- Run linked queries one at a time. After `failed to connect as temp role`, rerun that query once.
- A parse error in the output doesn't mean the write was rolled back. Read the state back before retrying.
