---
name: supabase-cli-gotchas
description: Avoid Supabase CLI traps - inconsistent output flags, db query argument rules, secrets printed by api-keys and status, local stacks and Edge Function secrets, functions deploy --prune deleting functions, and auditing deployed functions. Use when running supabase CLI commands for databases, migrations, local stacks or Edge Functions.
compatibility: Supabase CLI 2.110–2.117
metadata:
  verified: "2026-11"
  verified-with: "Supabase CLI 2.110.0 and 2.117.0"
---

# Supabase CLI traps

## Steps

- **Output flags differ:** `projects list` and `functions list` take `--output pretty`; `db query` takes `--output table`. In 2.117.0, `config diff` and `config push` take `--output-format json` and reject `--linked` (use `--project-ref` with `--workdir`).
- **`db query`:** inline SQL only as the single positional argument (there is no `--sql`); wrap SQL that contains single-quoted literals in double quotes. SQL that starts with a `--` comment needs `--file`, whose path is relative to `--workdir`. Several statements in one call can be rejected: split them, with cleanup last. `--project-ref <ref>` also needs `--linked` and can't target `--local` or `--db-url`.
- **`test db`:** test paths are positional and relative to the shell's current folder, not `--workdir`; it rejects `--file`.
- **`functions list`** takes its project from `--workdir` and rejects `--linked`.
- **Advisors:** `db advisors --type all --level warn --fail-on warn`. In 2.117.0, `--output json` (snake-case findings) and `--output-format json` (camel-case under `results`) give different shapes; keep your command and your parser together.
- **Audit deployed functions:** copy the whole owning workdir to a temporary folder, run `functions download --use-api --yes` there and diff against your source. Never download over the repository.
- **Local Edge Function secrets:** pass them with `functions serve --env-file <file>`; your shell environment doesn't reach the runtime. `rate_limit_unavailable` after authentication means a secret is missing. Use `PUBLISHABLE_KEY` from `supabase status --output env` for local calls; the legacy `ANON_KEY` can fail with `INVALID_CREDENTIALS`.
- **Second local stack:** a copied workdir needs its own `project_id` and its own ports in `[api]`, `[db]`, `[studio]`, `[local_smtp]` and `[analytics]`. If `start` goes silent after migrations, keep waiting, then check with `status`.
- **Setting function secrets (2.117.0):** put only `[edge_runtime.secrets]` entries with `env(NAME)` references in a temporary config, pass the values in the child process's environment, and run from that config's folder (set both the working directory and `--workdir`; `--workdir` alone doesn't select it). `secrets set --env-file /dev/stdin`, standard input and named pipes aren't reliable. `secrets list --output json` shows each secret's SHA-256 in the `value` field, so you can compare without printing secrets.
- **Multi-project repos:** pass the exact `--workdir` on every command.
- **Restricted sandboxes:** prefix commands with `SUPABASE_TELEMETRY_DISABLED=1`. If a linked command reports a missing token although a `Supabase CLI` Keychain item exists, or Docker reports a socket permission error, rerun the same command outside the sandbox.

## Check

Commands return their data, and `supabase stop --workdir <dir>` leaves no project containers running.

## Pitfalls

- `projects api-keys` prints service-role keys even without `--reveal`, and `start` and `status` print local secrets. Don't run them into logs.
- `functions deploy --prune` deletes every function you didn't name. Never combine it with a subset; for a full sync, name none and add `--yes` (without it, JSON mode can deploy and then fail before pruning).
- Run linked queries one at a time. After `failed to connect as temp role`, rerun that query once.
- A parse error in the output doesn't mean the write was rolled back. Read the state back before retrying, and remember `BEFORE` triggers run even when `ON CONFLICT` skips the row.
- If linked `migration squash` exits 0 without changes, rebuild the local stack and run `migration squash --local --version <latest>`.
