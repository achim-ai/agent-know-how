#!/usr/bin/env bash
# Checks each skill's format and that the plugin catalog and README index list exactly the folders in skills/.
set -euo pipefail
export LC_ALL=C
cd "$(dirname "$0")/.."

errors=0
fail() {
  echo "error: $*" >&2
  errors=$((errors + 1))
}

# Prints a frontmatter value, without surrounding quotes. Nested keys keep their indent, e.g. "  verified".
field() {
  awk -v key="$2: " '
    NR == 1 { if ($0 != "---") exit; next }
    $0 == "---" { exit }
    index($0, key) == 1 { value = substr($0, length(key) + 1); gsub(/^"|"$/, "", value); print value; exit }
  ' "$1"
}

has_frontmatter() {
  awk 'NR == 1 && $0 != "---" { exit 1 } NR > 1 && $0 == "---" { found = 1; exit } END { exit !found }' "$1"
}

count=0
for dir in skills/*/; do
  name=$(basename "$dir")
  file="skills/$name/SKILL.md"
  count=$((count + 1))
  if [[ ! "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || (( ${#name} > 64 )); then
    fail "skills/$name: folder name must be lowercase letters, numbers and single hyphens, at most 64 characters"
  fi
  if [[ ! -f "$file" ]]; then
    fail "skills/$name has no SKILL.md"
    continue
  fi
  if ! has_frontmatter "$file"; then
    fail "$file: frontmatter must start on line 1 with --- and end with ---"
    continue
  fi
  [[ "$(field "$file" name)" == "$name" ]] || fail "$file: name must be $name, the folder name"
  description=$(field "$file" description)
  if (( ${#description} < 1 || ${#description} > 1024 )) || [[ "$description" == [\>\|]* ]]; then
    fail "$file: description must be one line of 1 to 1024 characters"
  fi
  [[ -n "$(field "$file" '  verified')" ]] || fail "$file: set metadata.verified"
  [[ -n "$(field "$file" '  verified-with')" ]] || fail "$file: set metadata.verified-with"
  grep -qF "](skills/$name/SKILL.md)" README.md || fail "README.md: add $name to the skill index"
done

for linked in $(grep -oE '\]\(skills/[^/)]+/SKILL\.md\)' README.md | cut -d/ -f2); do
  [[ -d "skills/$linked" ]] || fail "README.md links to skills/$linked, which doesn't exist"
done

expected=$(for dir in skills/*/; do echo "./skills/$(basename "$dir")"; done)
listed=$(jq -r '.plugins[0].skills[]' .claude-plugin/marketplace.json)
if ! catalog_diff=$(diff <(echo "$expected") <(echo "$listed")); then
  fail ".claude-plugin/marketplace.json: the skills list must match the folders in skills/, sorted (< missing, > extra):"$'\n'"$catalog_diff"
fi

set +e
private=$(grep -rnE '/(Users|home)/[A-Za-z]' skills template README.md CONTRIBUTING.md)
grep_status=$?
set -e
case $grep_status in
  0) fail "replace private paths with placeholders like /Users/<you>:"$'\n'"$private" ;;
  1) ;;
  *) fail "the private path search failed" ;;
esac

if (( errors > 0 )); then
  echo "$errors problem(s) found" >&2
  exit 1
fi
echo "All $count skills OK"
