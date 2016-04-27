#!/usr/bin/env bash
# Installs some global-state tools on macOS.

set -euo pipefail

DOTFILES_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DOT_TMP_DIR=$(mktemp -d -t dotfiles)
cleanup () {
    rm -r "$DOT_TMP_DIR"
}
trap cleanup EXIT INT TERM ERR

# include library helpers for colorized ouput
# shellcheck source=lib.sh
source "$DOTFILES_DIR/lib.sh"

check-hash () {
    local SHA_SUM=$1
    local FILE="$DOT_TMP_DIR/$SHA_SUM.tmp"
    cat - > "$FILE"

    set +e
    echo "$SHA_SUM  $FILE" | shasum -s -a 256 -c
    local CODE=$?
    set -e

    if [ $CODE -ne 0 ]; then
        error 'Error matching checksums:'
        echo  "	computed: $(shasum -a 256 "$FILE" | awk '{print $1}')" 1>&2
        echo  "	expected: $SHA_SUM" 1>&2
        return 1
    fi

    cat "$FILE"
}

symlink-if-not-exist () {
    local LINK="$2"
    local BACKUP="$HOME/dotfiles-backup"
    running "symlinking $(abs_path_to_tilde "$LINK")"
    local LINK_SRC="$DOTFILES_DIR/$1"
    mkdir -p "$(dirname "$LINK")"

    if [[ -e $LINK ]]; then
        # file already exists
        if [[ -L $LINK ]]; then
            # it's already a symlink, check where it's pointing at
            points_to=$(readlink "$LINK")
            if [ "$points_to" == "$LINK_SRC" ]; then
                printf '\t%s\n' 'symlink exists, skipped'
                return
            fi
        fi

        # create backup of original file
        mkdir -p "$(dirname "$BACKUP/$1")"
        backup_file=$(mktemp "$BACKUP/$1.original.backup.XXXXXX")
        mv "$2" "$backup_file"
        printf '\t%s' 'backed up...';
    fi
    # create the link
    if ln -fs "$LINK_SRC" "$LINK"; then
        printf '\t%s\n' 'linked'
    fi
}

symlink-home-config () {
    symlink-if-not-exist "config/$1" "$HOME/$2"
}

git-install-to () {
    local GIT_URL=$1
    local DEST=$2
    running "cloning $GIT_URL to $(abs_path_to_tilde "$DEST")"
    if [ ! -d "$DEST" ]; then
        if ! git clone -q "$GIT_URL" "$DEST" > /dev/null 2>&1; then
            error "failed to clone $GIT_URL"
        else
            printf '\t%s\n' 'cloned'
        fi
    else
        printf '\t%s\n' 'already exists'
    fi
}

install_nix_app () {
    local attr="$1"
    local app="$2"
    running "installing $app"
    local app_path
    app_path=$(nix-build --pure \
        "$DOTFILES_DIR/config/nix/custom-packages.nix" \
        --no-out-link \
        --attr "$attr")
    rsync -rlp "$app_path/Applications/$app" "$DOT_TMP_DIR"
    chmod -R u+w "$DOT_TMP_DIR/$app"
    rsync -rlp "$DOT_TMP_DIR/$app" /Applications
    printf '\t%s\n' 'ok'
}

action 'install Nix'
if ! which nix-env > /dev/null 2>&1; then
    curl -fsS 'https://nixos.org/nix/install' \
        | check-hash \
            'f45a0fd52904e08cccd59bd28c34aaa47175032437a146c55b54f8271b9b3498' \
        | /bin/sh
else
    nop 'it looks like Nix is already installed.'
fi
ok

action 'setup Nix & install packages'
symlink-home-config 'nix/config.nix' '.nixpkgs/config.nix'
nix-env -iA nixpkgs.personalSystemEnv
ok

action 'setup git'
symlink-home-config 'git/config' '.gitconfig'
declare -a git_files=('ignore' 'template')
for filename in "${git_files[@]}"; do
    symlink-home-config "git/$filename" ".config/git/$filename"
done
ok

action 'setup zsh'
symlink-home-config 'zsh/zshrc' '.zshrc'
symlink-home-config 'zsh/zshenv' '.zshenv'
git-install-to 'git://github.com/zsh-users/zaw.git' ~/.zaw
ok

# action 'setup direnv'
# symlink-home-config 'direnv/direnvrc' '.config/direnv/direnvrc'
# ok

action 'setup neovim'
# create various directories necessary for neovim
vim_dir=~/.config/nvim
declare -a dirs=('autoload' 'plugged' 'ftplugin' 'colors' 'tmp')
for dir in "${dirs[@]}"; do
    mkdir -p "$vim_dir/$dir"
done
# symlink neovim init.vim files, color theme file, as well as various others
vim_files=$(
    vim_config="$DOTFILES_DIR/config/vim"
    find "$vim_config" -type f | sed "s|^$vim_config/||"
)
for filename in $vim_files; do
    symlink-home-config "vim/$filename" ".config/nvim/$filename"
done

running 'install/update plugins'
curl -fsSL \
        'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' \
    | check-hash \
        '726f2d0d8733a040d0ea722e9cd8b144f136f7864b75766a28de788ad89a48ca' \
    | cat > "$vim_dir/autoload/plug.vim"
nvim +PlugUpdate +qa
printf 'ok\n'

symlink-home-config 'vim/init.vim' '.vimrc' # for vim compatibility
legacy_vim_dir=~/.vim
if [[ ! -d "$legacy_vim_dir" ]];then
    ln -fFs "$vim_dir" "$legacy_vim_dir"
fi
ok

action 'setup tmux'
symlink-home-config 'tmux/tmux.conf' '.tmux.conf'
ok

action 'set shell to zsh'
# macOS uses Directory Service to store user shell information
login_shell=$(dscl . -read /Users/"$(whoami)" UserShell | awk '{print $2}')
if [[ $login_shell != *'zsh' ]]; then
    running 'changing your login shell to zsh'
    chsh -s "$(which zsh)"
    ok "now using \"$(which zsh)\""
else
    nop 'it looks like you are already using zsh.'
    ok
fi

action 'setup iTerm2'
plist_name='com.googlecode.iterm2.plist'
plist="$DOTFILES_DIR/config/iterm-app/$plist_name"
plist_dir=$(dirname "$(abs_path_to_tilde "$plist")")
plutil -replace 'PrefsCustomFolder' -string "$plist_dir" "$plist" \
    -o "$plist"
running 'copying .plist'
cp "$plist" ~/Library/Preferences/"$plist_name"
printf '\t%s\n' 'ok'
ok

action 'install applications (using Nix)'
# install_nix_app 'iterm2' 'iTerm.app'
# install_nix_app 'shiftit' 'ShiftIt.app'
# install_nix_app 'gitupbin' 'GitUp.app'
ok

action 'add local configuration files'
"$DOTFILES_DIR"/setup-local.sh
ok

bot 'All ready to go !'
