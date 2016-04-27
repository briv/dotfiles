#!/usr/bin/env bash
# Creates some local configuration files.

set -euo pipefail

DOTFILES_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# include library helpers for colorized ouput
# shellcheck source=lib.sh
# source "$DOTFILES_DIR/lib.sh"
source "$DOTFILES_DIR/lib.sh"

create_local () {
    local type="${1}"
    local file="${2}"
    local fn="${3}"
    if [ ! -f "$file" ]; then
        printf "Create a local %s config file @'%s' ? [yes/no]\n" \
            "$type" "$file"
        read -r resp
        if [ "$resp" != 'yes' ]; then
            exit 0
        fi

        mkdir -p "$(dirname "$file")"
        "$fn" "$file"
    else
        nop "$(abs_path_to_tilde "$file") already exists"
    fi
}

make_git_config () {
    echo "Please enter your name, for example 'John Smith':"
    read -r name

    echo "Please enter your email:"
    read -r email

    printf '[user]\n\tname = %s\n\temail = %s\n' "$name" "$email" > "$1"
}

make_zsh_config () {
    printf '%s\n\n%s\n' \
    '## This file is useful for secrets and local environment additions' \
    '# export HOMEBREW_GITHUB_API_TOKEN=' > "$1"
}

local_gitconfig=~/.config/git/config.local
create_local 'git' "$local_gitconfig" make_git_config

local_zshconfig=~/.config/zsh/local.zsh
create_local 'zsh' "$local_zshconfig" make_zsh_config
