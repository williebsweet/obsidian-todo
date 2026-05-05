# Raycast Store Manual Publish

This repository is set up to avoid `npm run publish` / `npx ray publish` for public Store submissions.

## Why

Raycast's public publish flow uses GitHub OAuth with broad repository access. The safer workflow is to publish manually through a fork of `raycast/extensions`.

## Local Setup

- Source repo: `~/Documents/GitHub/obsidian-todo`
- Submission fork: `https://github.com/williebsweet/extensions`
- Sparse checkout: `~/Documents/GitHub/raycast-extensions-submit`
- SSH host alias: `github.com-raycast-obsidian-todo`
- Dedicated deploy key: `~/.ssh/raycast-extensions-obsidian-todo`

The deploy key is attached only to `williebsweet/extensions`, so it cannot be used to access other repositories.

## Publish Flow

1. Update the submission workspace:

   ```bash
   git -C ~/Documents/GitHub/raycast-extensions-submit fetch upstream
   git -C ~/Documents/GitHub/raycast-extensions-submit checkout main
   git -C ~/Documents/GitHub/raycast-extensions-submit merge --ff-only upstream/main
   git -C ~/Documents/GitHub/raycast-extensions-submit push origin main
   ```

2. Sync this extension into the sparse checkout:

   ```bash
   ./scripts/sync-to-raycast-fork.sh
   ```

3. Create a submission branch and commit from the sparse checkout:

   ```bash
   cd ~/Documents/GitHub/raycast-extensions-submit
   git checkout -b submit/obsidian-todo-$(date +%Y%m%d-%H%M%S)
   git add extensions/obsidian-todo
   git commit -m "Add obsidian-todo extension"
   git push -u origin HEAD
   ```

4. Open the upstream PR in the browser:

   ```bash
   open "https://github.com/raycast/extensions/compare/main...williebsweet:extensions:$(git branch --show-current)?expand=1"
   ```

## Notes

- The sparse checkout only includes `extensions/obsidian-todo`.
- The sync script excludes `.git`, `node_modules`, `dist`, `.DS_Store`, and `raycast-env.d.ts`.
- Keep using this repo for development. Use the sparse checkout only for Store submission branches.
