
# Personal Hermes subagent skills

Three subagent skills for Hermes Agent. Each one teaches any Hermes profile to
automatically delegate a specialized task to a focused child agent running
Claude Haiku 4.5 via an Anthropic subscription.

Once installed, the skills load into every session on that machine. You do not
need to invoke them explicitly. Just describe what you want in plain language
and the parent agent routes the work to the right specialist.

---

## Skills

### email-composer-subagent

Writes new emails from scratch or revises a supplied draft.

When to call it: ask to write, draft, revise, polish, or adjust the tone of an
email. The child agent produces a professional, warm, concise message that
sounds like a person wrote it. It does not send email.

### github-repo-reviewer-subagent

Read-only analysis of a GitHub repository given its URL.

When to call it: ask what a repo does, whether it is worth installing, how to
deploy it in a home lab, how to configure it, what its code or security looks
like, or why something is broken. The child searches the web and repository
content and returns a structured report ending with a clear recommendation
verdict.

### macos-uninstaller-subagent

Inspected, confirmation-gated removal of a macOS application and all verified
application-owned residue.

When to call it: ask to uninstall, remove, or clean up a Mac app. The child
runs in two phases: it first inspects and presents an exact removal plan, then
waits for your explicit confirmation before deleting anything. It never removes
shared components, user data, or files it cannot prove belong to the target
application.

---

## Requirements

- Hermes Agent v0.22.0 or later
- Anthropic subscription OAuth credential configured
  (`hermes auth add anthropic --type oauth`)
- The subagents pin to `claude-haiku-4-5-20251001` via Anthropic regardless of
  which model the parent profile uses

---

## Install

### Option 1 — clone and run the installer (recommended)

```sh
git clone git@github.com:tko76/hermes-skills.git
cd hermes-skills
chmod +x install.sh
./install.sh
```

Install individual skills:

```sh
./install.sh email-composer-subagent
./install.sh github-repo-reviewer-subagent
./install.sh macos-uninstaller-subagent
```

### Option 2 — install directly from raw GitHub URLs

```sh
hermes skills install \
  https://raw.githubusercontent.com/tko76/hermes-skills/main/skills/email-composer-subagent/SKILL.md \
  --yes

hermes skills install \
  https://raw.githubusercontent.com/tko76/hermes-skills/main/skills/github-repo-reviewer-subagent/SKILL.md \
  --yes

hermes skills install \
  https://raw.githubusercontent.com/tko76/hermes-skills/main/skills/macos-uninstaller-subagent/SKILL.md \
  --yes
```

### Option 3 — manual copy

```sh
git clone git@github.com:tko76/hermes-skills.git
mkdir -p ~/.hermes/skills/email-composer-subagent \
         ~/.hermes/skills/github-repo-reviewer-subagent \
         ~/.hermes/skills/macos-uninstaller-subagent

cp hermes-skills/skills/email-composer-subagent/SKILL.md \
   ~/.hermes/skills/email-composer-subagent/SKILL.md
cp hermes-skills/skills/github-repo-reviewer-subagent/SKILL.md \
   ~/.hermes/skills/github-repo-reviewer-subagent/SKILL.md
cp hermes-skills/skills/macos-uninstaller-subagent/SKILL.md \
   ~/.hermes/skills/macos-uninstaller-subagent/SKILL.md
```

---

## After installing

The skills load automatically in every new session on that machine.

If you have a Hermes session already open, restart it:

```
/new
```

Verify the skills are active:

```
hermes skills list
```

---

## Updating

```sh
cd hermes-skills
git pull --ff-only
./install.sh
```

Each `hermes skills install` call overwrites the previous version, so
re-running the installer is safe.

---

## Authenticating with Anthropic

The subagents are pinned to the Anthropic provider. Each Hermes installation
needs its own Anthropic credential. The credential is not stored in this repo
and is not portable between machines.

On each machine:

```sh
hermes auth add anthropic --type oauth
```

Follow the browser prompt. The credential is stored in `~/.hermes/auth.json`
on that machine only.

---

## What these skills are not

These are delegation routing skills, not chat profiles. They teach the parent
agent when and how to spawn a focused child agent for each task. The child runs
in its own isolated context window and returns only the result, keeping the
parent conversation clean.

If you want to have a full back-and-forth conversation with a specialist
directly — for example, to let the macOS uninstaller walk through interactive
confirmation steps — install the matching Hermes profile distributions
separately (not included in this repo).
