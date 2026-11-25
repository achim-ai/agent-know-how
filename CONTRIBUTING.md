# Contributing

Add what you or your agent had to figure out the hard way: a hidden flag, a prompt to avoid, a tool quirk, a setup that finally worked.

## Add a skill

1. Copy [`template/SKILL.md`](template/SKILL.md) to `skills/<name>/SKILL.md`. The `name` must match the folder: lowercase letters, numbers and hyphens.
2. Fill it in. Keep it short: steps someone can follow and one check that proves it worked.
3. Add the folder to the `skills` list in [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json) and a row to the table in the [README](README.md).
4. Open a pull request.

Scripts or files a skill needs go in its folder (`scripts/`, `assets/`), following the [Agent Skills format](https://agentskills.io/specification).

## Fix or update a skill

Edit it and set `verified` and `verified-with` to what you just ran. If a skill is wrong and you can't fix it, open an issue with what failed and your versions.

## Rules

- **Only what you ran.** Every step must have worked on your machine, on the versions you list.
- **One topic, one skill.** Extend an existing skill instead of adding a near-duplicate.
- **No personal data.** No names, emails, tokens, hostnames, private paths or project names. Use placeholders.
- **Safe by default.** No steps that turn off security features, share credentials or delete data without a check first.
