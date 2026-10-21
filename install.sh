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
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
SKILLS_DIR="$HERMES_HOME/skills"

install_skill() {
    name="$1"
    src="$REPO_ROOT/skills/$name/SKILL.md"
    dest_dir="$SKILLS_DIR/$name"
    dest="$dest_dir/SKILL.md"

    if [ ! -f "$src" ]; then
        printf 'Not found: %s\n' "$src" >&2
        exit 1
    fi

    mkdir -p "$dest_dir"

    if [ -f "$dest" ] && cmp -s "$src" "$dest"; then
        printf 'Unchanged: %s\n' "$name"
        return 0
    fi

    cp -p "$src" "$dest"
    printf 'Installed: %s -> %s\n' "$name" "$dest"
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

printf '\nDone. Skills load automatically in every new Hermes session.\n'
printf 'If Hermes is open, run /new to pick them up.\n'
