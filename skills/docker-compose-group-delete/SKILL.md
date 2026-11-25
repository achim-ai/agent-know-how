---
name: docker-compose-group-delete
description: Delete container groups (for example local Supabase stacks) that Docker Desktop's UI won't delete, and remove containers and images in the right order. Use when deleting a container group in Docker Desktop hangs or does nothing, or docker rmi fails with a conflict.
compatibility: Docker Desktop on macOS
metadata:
  verified: "2026-11"
  verified-with: "Docker Desktop on macOS 27.2"
---

# Delete stuck Compose container groups

Docker Desktop shows containers with a `com.docker.compose.project` label as one group. Members without the `com.docker.compose.config-hash` label are left out of the group's Compose actions, so deleting the group does nothing.

## Steps

1. List the group's containers with both labels:

   ```bash
   docker ps -a --filter label=com.docker.compose.project=<project> --format '{{.ID}} {{.Names}} {{.Label "com.docker.compose.config-hash"}}'
   ```

2. Stop and delete those exact container IDs: `docker rm -f <id> <id> …`.
3. Delete images only after their containers: `docker rmi <image-id>`.

## Check

Step 1's command prints nothing.

## Pitfalls

- Deleting an image while a stopped container still uses it fails with a 409 conflict.
- Don't use `docker volume prune` or broad `prune` commands for this: volumes can hold databases you still need.
