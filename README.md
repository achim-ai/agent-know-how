# agent-know-how

Field-tested agent skills for Claude Code, Codex and other coding agents: practical fixes for real setups that agents otherwise rediscover the hard way. Every skill says when it was last verified and on which versions.

## 1. Let your agent use it

**Install the skills (recommended).** Your agent then loads only each skill's name and description at startup, about 100 tokens per skill, and reads the full skill only when a task matches. No searching needed.

Claude Code:

```
/plugin marketplace add achim-ai/agent-know-how
/plugin install agent-know-how@achim-ai
```

Codex:

```bash
codex plugin marketplace add achim-ai/agent-know-how
codex plugin add agent-know-how@achim-ai
```

Cursor, OpenCode and other agents that read [Agent Skills](https://agentskills.io):

```bash
npx skills add achim-ai/agent-know-how
```

**Or point your agent here without installing.** Add this line to your `AGENTS.md` or `CLAUDE.md`:

```
Before tasks involving Xcode, simulators, Flutter, Supabase, Docker, GitHub, macOS tooling, Claude Code or Codex, check the skill index at https://github.com/achim-ai/agent-know-how#skills and read only the matching SKILL.md.
```

## 2. Contribute

Your agent figured something out the hard way? Add it so the next agent doesn't have to:

1. Copy [`template/SKILL.md`](template/SKILL.md) to `skills/<name>/SKILL.md` and fill it in.
2. Add it to the index below and to [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json).
3. Open a pull request.

Only include what you actually ran, and no personal data. Agents: ask your user before opening a pull request. Details in [CONTRIBUTING.md](CONTRIBUTING.md).

## Skills

### Claude Code and Codex

| Skill | Use when |
| --- | --- |
| [claude-desktop-open-links-in-browser](skills/claude-desktop-open-links-in-browser/SKILL.md) | `file://` links in Claude desktop open in the built-in pane instead of the browser |
| [claude-chat-inline-screenshots](skills/claude-chat-inline-screenshots/SKILL.md) | Images don't render in Claude desktop replies |
| [claude-code-allow-rules](skills/claude-code-allow-rules/SKILL.md) | Allowed commands still ask for permission |
| [claude-prompt-free-simulators](skills/claude-prompt-free-simulators/SKILL.md) | Claude desktop asks for simulator device access |
| [claude-calls-codex](skills/claude-calls-codex/SKILL.md) | Delegating from Claude to Codex, quota check |
| [codex-calls-claude](skills/codex-calls-claude/SKILL.md) | Calling Claude Code from Codex or scripts |

### Xcode, simulators and Apple testing

| Skill | Use when |
| --- | --- |
| [xcuitest-runner-stalls](skills/xcuitest-runner-stalls/SKILL.md) | UI test runs hang, die or fail to install |
| [xcodebuild-only-testing-selectors](skills/xcodebuild-only-testing-selectors/SKILL.md) | Focused test runs run zero tests or the wrong device |
| [xcresult-pass-check](skills/xcresult-pass-check/SKILL.md) | Deciding whether a test run really passed |
| [xcuitest-gotchas](skills/xcuitest-gotchas/SKILL.md) | Launch, deep link, text entry and query traps in UI tests |
| [xcuitest-landscape-orientation](skills/xcuitest-landscape-orientation/SKILL.md) | Landscape UI tests stay portrait |
| [visionos-simulator-screenshots](skills/visionos-simulator-screenshots/SKILL.md) | Vision Pro screenshots miss presented sheets |
| [macos-ui-tests-unattended](skills/macos-ui-tests-unattended/SKILL.md) | Mac UI tests hang on Automation Mode or a locked screen |
| [xcode-command-line-builds](skills/xcode-command-line-builds/SKILL.md) | Builds fail in an agent sandbox or after an Xcode update |
| [xcode-validate-resources](skills/xcode-validate-resources/SKILL.md) | Validating plists, schemes, String Catalogs, entitlements |
| [storekit-local-testing](skills/storekit-local-testing/SKILL.md) | In-app purchases in the simulator |

### Flutter, Dart and backends

| Skill | Use when |
| --- | --- |
| [flutter-dart-gotchas](skills/flutter-dart-gotchas/SKILL.md) | Analyzer, test, Drift, CocoaPods and Gradle traps |
| [flutter-web-driver-chrome-match](skills/flutter-web-driver-chrome-match/SKILL.md) | Flutter web integration tests won't start |
| [supabase-cli-gotchas](skills/supabase-cli-gotchas/SKILL.md) | Supabase CLI flags, secrets and function deploys |
| [docker-compose-group-delete](skills/docker-compose-group-delete/SKILL.md) | Docker Desktop won't delete a container group |

### macOS, Git and GitHub

| Skill | Use when |
| --- | --- |
| [dev-disk-cleanup-macos](skills/dev-disk-cleanup-macos/SKILL.md) | The disk is full after development and testing |
| [macos-shell-gotchas](skills/macos-shell-gotchas/SKILL.md) | zsh, system Ruby and Python traps |
| [macos-keychain-cli](skills/macos-keychain-cli/SKILL.md) | Storing tokens in the Keychain from the terminal |
| [ssh-commit-signature-verify](skills/ssh-commit-signature-verify/SKILL.md) | Checking SSH-signed commits |
| [github-mark-notifications-done](skills/github-mark-notifications-done/SKILL.md) | Clearing GitHub notifications from the CLI |
| [github-copilot-review-quota](skills/github-copilot-review-quota/SKILL.md) | Copilot reviews use up quota unexpectedly |

## License

[BSD 3-Clause](LICENSE)
