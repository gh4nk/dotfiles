#!/bin/bash
HELP="Usage: sudo ./install.sh <operation> [...]
Automatically install packages and bootstrap dotfiles

operations:
        -f, --force
        --mac
        --arch
        --debian
"

source $(dirname "$0")/shared.sh
source $(dirname "$0")/bootstrap.sh
source $(dirname "$0")/packages.sh
# if no arguments are provided, return usage function
if [ $# -eq 0 ]; then
    usage # run usage function
    exit 1
fi

for arg in "$@"; do
    case $arg in
    -t | --tag)
        TAG=$2
        shift # Remove argument (-t) name from `$@`
        shift # Remove argument value (latest) from `$@`
        ;;
    -f | --force)
        FORCE=true
        shift
        ;;
    -h | --help)
        usage # run usage function on help
        ;;
    --mac)
        MAC_OS=true
        installMac
        ;;
    --arch)
        ARCH_OS=true
        installArch
        ;;
    --debian)
        DEBIAN_OS=true
        installDebian
        ;;
    *)
        usage # run usage function if wrong argument provided
        ;;
    esac
done

function installMac(){
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    installSpacemacs
    installVimconfig
    installAntigen
    brew update
    packageIterator "brew" "${BASE_PACKAGES[@]}"
    packageIterator "brew" "${BREW_PACKAGES[@]}"
    brew cleanup
    ./bootstrap.sh --mac
}

function installDebian(){
    sshKeys
    installAntigen
    installVimconfig
    sudo -u "$SUDO_USER" apt-get update
    packageIterator "apt" "${BASE_PACKAGES[@]}"
    ./bootstrap.sh --debian
}

function installArch(){
    sshKeys
    sudo ./arch.sh -at GUI
    installAntigen
    installVimconfig
    ./bootstrap.sh --arch
}

function usage(){
    echo $HELP
}
