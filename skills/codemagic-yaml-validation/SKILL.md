---
name: codemagic-yaml-validation
description: Validate codemagic.yaml locally before pushing - schema validation with defaults resolved, the empty-variable check that otherwise makes Codemagic reject the whole file, script syntax, per-step logs that still fail the step, and managed iOS signing rules the schema doesn't enforce. Use before committing any codemagic.yaml change.
compatibility: Codemagic YAML workflows; Ruby and Bash on the local machine
metadata:
  verified: "2026-11"
  verified-with: "Codemagic schema (codemagic.io/codemagic-schema.json), November 2026"
---

# Validate codemagic.yaml before pushing

## Steps

1. Parse the file with aliases (`YAML.safe_load(File.read("codemagic.yaml"), aliases: true)`), list every workflow including manual ones, and require a nonempty `name` on each.
2. Validate the raw file and every workflow, with `inputs` defaults filled in, against the [current schema](https://codemagic.io/codemagic-schema.json).
3. Run the empty-variable check. One empty value in any workflow's `environment.vars` makes Codemagic reject the whole file:

   ```bash
   ruby -ryaml -e '
   config = YAML.safe_load(File.read(ARGV.fetch(0)), aliases: true)
   workflows = config.fetch("workflows")
   abort "No workflows found" unless workflows.is_a?(Hash) && !workflows.empty?
   pattern = /\$\{\{\s*inputs\.([a-zA-Z]\w*)\s*\}\}/
   count = 0
   workflows.each do |id, workflow|
     inputs = workflow.fetch("inputs", {})
     workflow.fetch("environment", {}).fetch("vars", {}).each do |name, raw|
       value = raw
       if raw.is_a?(String)
         match = raw.match(/\A#{pattern.source}\z/)
         value = match ? inputs.fetch(match[1]).fetch("default") : raw.gsub(pattern) { inputs.fetch(Regexp.last_match(1)).fetch("default").to_s }
       end
       valid = (value.is_a?(String) && !value.empty?) || value.is_a?(Numeric) || value == true || value == false
       abort "#{id}.environment.vars.#{name}: invalid default-resolved value" unless valid
       count += 1
     end
   end
   puts "Checked #{workflows.length} workflows and #{count} environment values"
   ' codemagic.yaml
   ```

4. Syntax-check every `script` with `/bin/bash -n`.
5. To keep a log per step and still fail the step, run each script's commands in a subshell piped to a log, with `set -euo pipefail` outside it:

   ```yaml
   scripts:
     - name: Get Packages
       script: |
         #!/usr/bin/env bash
         set -euo pipefail
         mkdir -p "$CM_BUILD_DIR/build/logs"
         (
           flutter pub get
         ) 2>&1 | tee "$CM_BUILD_DIR/build/logs/get-packages.log"
   artifacts:
     - $CM_BUILD_DIR/build/logs/*.log
   ```

## Check

The schema validation and empty-variable check pass, every script passes `bash -n`, and a deliberately failing command produces its log and a nonzero step result.

## Pitfalls

- Managed `ios_signing` needs a distribution type with a bundle identifier, or a nonempty `provisioning_profiles` list. Certificates alone are invalid, even though the public schema accepts them.
- Managed-signing Flutter builds pass Codemagic's generated `/Users/builder/export_options.plist` to `flutter build ipa`.
- Pin an explicit Xcode version; don't use `latest` or `edge`.
- For full Git history (for example build numbers from `git rev-list --count`), set `CM_CLONE_UNSHALLOW: 'true'`.
- Pass values that start with a hyphen as `--option=value`.
- Local checks only verify configuration. A fix is proven when Codemagic accepts the corrected revision and the failing stage passes.
