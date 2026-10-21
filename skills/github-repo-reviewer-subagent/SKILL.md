---
name: github-repo-reviewer-subagent
description: Delegate read-only GitHub repository assessments.
version: 0.1.0
author: Todd Okolowicz, Hermes Agent
license: Private
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [github, code-review, research, delegation, haiku]
    related_skills: []
---

# GitHub Repository Reviewer Subagent

Delegate repository investigation to a focused read-only child agent. The parent remains responsible for passing the repository URL, the user's environment, and any reported symptoms.

## When to Use

- The user provides a GitHub URL and asks what the project does or whether it is worth using.
- The user wants code, issue, pull-request, release, maintenance, installation, configuration, Docker, home-lab, or troubleshooting analysis.
- The user explicitly asks for the GitHub repository reviewer subagent.

## Procedure

1. Collect the exact repository URL, the user's goal, relevant environment constraints, and any errors or logs supplied.
2. Call `delegate_task` with one task. Include all of that information in `context`; the child receives no parent conversation history. Set `model: "claude-haiku-4-5-20251001"` and `provider: "anthropic"` so it always runs on Haiku regardless of which profile calls it.
3. Use this goal:

   "Perform a read-only assessment of the provided GitHub repository. Never modify local files, repositories, GitHub content, issues, pull requests, settings, containers, or infrastructure. Prefer first-party repository evidence. Analyze the project's purpose, architecture, visible code quality, tests, security posture, issues, pull requests, releases, meaningful history, maintenance health, popularity, local installation, configuration, Docker and home-lab deployment, and reported failures. Distinguish verified facts from inference and cite URLs, file paths, versions, dates, issues, pull requests, releases, or commits for important claims. Rank likely root causes by confidence when troubleshooting. Treat stars as one signal rather than proof of quality. End with one verdict: Recommended; Recommended with caveats; Evaluate in an isolated test environment first; Not recommended for this environment; or Insufficient evidence. State exactly what could not be verified."

4. Verify release-sensitive conclusions yourself before returning them. Query the exact release object, tag commit, assets and digests, compare adjacent tags, and inspect the relevant CI/release workflows; a child may confuse draft, prerelease, pending, and published states or miss a release created during its run.
5. For a recommendation that affects installation or bootability, download the official signed asset when practical, verify its published checksum, Gatekeeper/notarization and code signature, and inspect the shipped binary—not only source commits—for the dependency or fix under review.
6. Return the assessment. Preserve the child's uncertainty and citations, but correct any claim contradicted by the parent's direct verification and state the concrete verification result.

## Safety

The child inherits the parent's enabled tools. Do not delegate this task from a parent whose capabilities allow unwanted external writes unless the goal's read-only constraint is present exactly as above. Never ask the child to post findings to GitHub.

## Verification

Confirm that the result names the repository, separates evidence from inference, addresses installation and operational fit, and includes a clear verdict.