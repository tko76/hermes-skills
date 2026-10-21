---
name: macos-uninstaller-subagent
description: Delegate inspected, confirmation-gated Mac app removal.
version: 0.1.0
author: Todd Okolowicz, Hermes Agent
license: Private
platforms: [macos]
metadata:
  hermes:
    tags: [macos, uninstall, cleanup, delegation, haiku]
    related_skills: []
---

# macOS Uninstaller Subagent

Use a two-phase delegation workflow to inspect and remove a macOS application. The parent agent owns user interaction because delegated children cannot use `clarify`.

## When to Use

- The user asks to uninstall, completely remove, or purge a macOS application.
- The user asks to find and remove application-owned residue.
- The user explicitly asks for the macOS uninstaller subagent.

Do not use this workflow for ordinary documents or protected macOS system applications.

## Phase 1: Inspection

1. Call `delegate_task` with one task containing the exact app name and any known path or installation source. Set `model: "claude-haiku-4-5-20251001"` and `provider: "anthropic"` on both delegation calls so they always run on Haiku regardless of which profile calls them.
2. Use this goal:

   "Inspect the specified macOS application without changing the system. Identify its exact bundle path, bundle identifier, executable, version, signing identity, team identifier, package-manager or installer ownership, exact running processes, launch agents and daemons, login and background items, privileged helpers, extensions, Dock entries, receipts, preferences, caches, containers, logs, support directories, root-owned state under /var/db, user and system DiagnosticReports, downloaded installer media, mounted installer volumes, and other application-owned residue. Treat broad name and Spotlight matches as leads only. Prove ownership through bundle IDs, signatures, plist data, receipts, path structure, or documented vendor relationships. Preserve shared runtimes, frameworks, system databases, package-manager infrastructure, similarly named applications, and user-created documents or data unless ownership and deletion intent are certain. Return the exact proposed action list in the response, including every exact path, data-loss and backup warnings, uncertain items to preserve, and verification checks. Do not write report files or action manifests unless the parent explicitly requests artifacts. Do not delete, stop, unregister, reset, unload, or modify anything."

3. Present the child's exact plan to the user.
4. Ask the user to explicitly confirm the listed actions. Do not proceed from the original uninstall request alone.

## Phase 2: Confirmed Removal

After confirmation, call a new `delegate_task` child. Include the complete approved action and path list in `context` so the child cannot broaden scope.

Use this goal:

"Execute only the explicitly confirmed macOS application-removal actions and exact paths supplied in context. Keep Hermes command approvals active. Quote every path; do not use broad globs, name-only recursive deletion, or unbounded find-delete commands. Use a documented vendor uninstaller or owning package manager where appropriate, but inspect cleanup or zap behavior before use. Gracefully stop verified processes, remove only confirmed app-owned components, and use sudo only for a verified privileged component. Do not remove shared components or user-created data. Verify the app bundle and every approved path are absent; check processes, package inventory, receipts, Launch Services, launch items, helpers, extensions, login/background items, TCC state, and Dock entries as applicable. Report every removed item, every preserved item, every failed action, and anything requiring restart, logout, Recovery Mode, vendor tooling, or administrator approval. Never claim complete removal if verification is incomplete."

## Verification

The parent must confirm that the execution result stayed within the approved list and includes post-removal checks. If a child cannot execute an already approved exact path because of its narrower command policy, the parent may perform that same exact action directly; do not ask the user to reconfirm unchanged scope. For confirmed root-owned paths, a parent may invoke an exact `osascript` administrator-authorization command so macOS collects the password without exposing it to the agent.

After the first removal pass, independently search `/var/db`, user and system DiagnosticReports, Downloads, mounted volumes, and Launch Services again. If this finds a new candidate path, preserve it and obtain a new user confirmation before removal. Repeat this confirmation-and-verification cycle until only explicitly preserved items remain.