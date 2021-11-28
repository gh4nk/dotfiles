#!/bin/bash

function banner() {
    RED='\033[0;31m'
    YELLOW='\033[0;33m'
    CYAN='\033[0;36m'
    NC='\033[0m'
    TEXT=$CYAN
    BORDER=$YELLOW
    EDGE=$(echo "  $1  " | sed 's/./~/g')

    if [ "$2" == "warn" ]; then
        TEXT=$YELLOW
        BORDER=$RED
    fi

    MSG="${BORDER}~ ${TEXT}$1 ${BORDER}~${NC}"
    echo -e "${BORDER}$EDGE${NC}"
    echo -e "$MSG"
    echo -e "${BORDER}$EDGE${NC}"
}

function rootValidator() {
    if [ "$(whoami)" != "root" ]; then
        echo "$HELP"
        exit 1
    fi
}

function packageIterator() {
    local MANAGER="$1"
    shift
    local PACKAGES=("$@")

    for i in "${PACKAGES[@]}";
    do
        if [ "$MANAGER" == brew]; then
            if ! brew install $i; then
                banner "I was unable to install the package $i" "warn"
                exit 1
            fi
            continue
        fi

        if [ "$MANAGER" == apt]; then
            if ! sudo -u "$SUDO_USER" apt-get install "$i"; then
                banner "I was unable to install the package $i" "warn"
                exit 1
            fi
            continue
        fi

        if [ "$MANAGER" == yay ]; then
            if ! sudo -u "$SUDO_USER" yay -S "$i" -q --noconfirm; then
                banner "I was unable to install the package $i" "warn"
                exit 1
            fi
            continue
        fi

        if ! pacman -S "$i" --quiet --noconfirm; then
            banner "I was unable to install the package $i" "warn"
            exit 1
        fi

    done
}

function installSpacemacs() {
    if [ "$(uname -m)" == 'x86_64' ]; then
        banner "I will install spacemacs"

        sudo -u "$SUDO_USER" -- sh -c "
        git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d &>/dev/null
        cd ~/.emacs.d
        git checkout develop &>/dev/null
        cd - &>/dev/null"
    fi
}

function installAntigen(){
    curl -L git.io/antigen > $HOME/.antigen.zsh
}

function installVimconfig(){
    git clone --depth=1 https://github.com/amix/vimrc.git $HOME/.vim_runtime
    sh $HOME/.vim_runtime/install_awesome_vimrc.sh

}
function sshKeys() {
    banner "I'll import gh4nk's SSH keys"

    sudo -u "$createVal" -- sh -c "
    mkdir ~/.ssh
    chmod 700 ~/.ssh
    curl https://github.com/gh4nk.keys -o ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys"
}
