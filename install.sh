#!/bin/sh
# install.sh — install personal Hermes subagent skills
#
# Usage:
#   ./install.sh                  install all three skills
#   ./install.sh email-composer-subagent
#   ./install.sh github-repo-reviewer-subagent
#   ./install.sh macos-uninstaller-subagent
#
# Requires Hermes Agent v0.22.0+
# https://hermes-agent.nousresearch.com

set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

install_skill() {
    name="$1"
    src="$REPO_ROOT/skills/$name/SKILL.md"
    if [ ! -f "$src" ]; then
        printf 'Not found: %s\n' "$src" >&2
        exit 1
    fi
    printf 'Installing %s ...\n' "$name"
    hermes skills install "$src" --yes
}

if [ "$#" -eq 0 ]; then
    install_skill email-composer-subagent
    install_skill github-repo-reviewer-subagent
    install_skill macos-uninstaller-subagent
else
    for skill in "$@"; do
        case "$skill" in
            email-composer-subagent|github-repo-reviewer-subagent|macos-uninstaller-subagent)
                install_skill "$skill"
                ;;
            *)
                printf 'Unknown skill: %s\n' "$skill" >&2
                exit 2
                ;;
        esac
    done
fi

printf '\nAll requested skills installed.\n'
printf 'The skills load automatically in every new Hermes session.\n'
printf 'Restart any currently-open Hermes chat with /new for them to take effect.\n'
