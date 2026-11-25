#!/bin/bash
# Usage: verify-ssh-commit.sh <repo-path> <commit> <public-key-file>
set -euo pipefail
repository=$1
revision=$2
public_key=$3
read -r signing_type signing_bytes signing_comment < "$public_key"
signature_parser='import sys
raw=sys.stdin.buffer.read()
head,separator,body=raw.partition(b"\n\n")
assert separator
kept=[];signature=[];is_signature=False
for line in head.split(b"\n"):
    if line.startswith(b"gpgsig "):
        assert not signature
        signature.append(line[len(b"gpgsig "):]);is_signature=True
    elif is_signature and line.startswith(b" "):
        signature.append(line[1:])
    else:
        is_signature=False;kept.append(line)
assert signature[0]==b"-----BEGIN SSH SIGNATURE-----"
assert signature[-1]==b"-----END SSH SIGNATURE-----"
sys.stdout.buffer.write((b"\n".join(signature)+b"\n") if sys.argv[1]=="signature" else (b"\n".join(kept)+b"\n\n"+body))'
extract_commit_part() { git -C "$1" cat-file commit "$2" | python3 -B -c "$signature_parser" "$3"; }
commit_sha=$(git -C "$repository" rev-parse "${revision}^{commit}")
extract_commit_part "$repository" "$commit_sha" data | ssh-keygen -Y verify -f <(printf '%s %s %s\n' signer "$signing_type" "$signing_bytes") -I signer -n git -s <(extract_commit_part "$repository" "$commit_sha" signature)
