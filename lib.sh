function abs_path_to_tilde() {
    local abs_path="$1"
    local tilde_dir
    tilde_dir=$(
        cd "$(dirname "$abs_path")" || return 1
        dirs
    )
    echo "$tilde_dir/$(basename "$abs_path")"
}

###
# some bash library color helpers
# @author Adam Eivy
###

ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

function ok() {
    echo -e "$COL_GREEN[ok]$COL_RESET ${1:-}"
}

function bot() {
    echo -e "\n$COL_BLUE\[._.]/$COL_RESET - ${1:-}"
}

function running() {
    echo -en "$COL_YELLOW ⇒ $COL_RESET${1:-}: "
}

function nop() {
    echo -e "$COL_YELLOW ⇒ $COL_RESET${1:-}" # •
}

function action() {
    echo -e "\n$COL_YELLOW[${1:-}]:$COL_RESET"
}

function warn() {
    echo -e "$COL_YELLOW[warning]$COL_RESET ${1:-}"
}

function error() {
    echo -e "$COL_RED[error]$COL_RESET ${1:-}" 1>&2
}
