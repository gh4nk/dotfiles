#!/bin/bash
HELP="Usage: sudo ./bootstrap.sh <operation> [...]
Automatically bootstrap dotfiles

operations:
        -f, --force
        --mac
        --arch
        --debian
"

# if no arguments are provided, return usage function
if [ $# -eq 0 ]; then
    usage # run usage function
    exit 1
fi

for arg in "$@"; do
    case $arg in
        -f | --force)
            FORCE=true
            shift
            ;;
        -h | --help)
            usage # run usage function on help
            ;;
        --mac)
            MAC_OS=true
            break;
            ;;
        --arch)
            ARCH_OS=true
            break;
            ;;
        --debian)
            DEBIAN_OS=true
            break;
            ;;
        *)
            usage # run usage function if wrong argument provided
            ;;
    esac
done

BASIC_DOTFILES=(
    'zshrc'
    'aliases'
    'functions'
    'config/neofetch/config.conf'
)
GUI_DOTFILES=(
    'zshenv'
    'spacemacs'
    'gitconfig'
    'gitmessage'
    'gitignore'
)
ALL_DOTFILES=(
    'xbindkeysrc'
    'zprofile'
    'config/*'
)

function linkFiles(){
    local DOTFILES=("$@")

    for i in "${DOTFILES[@]}";
    do
        ln -sf ../"$i" $HOME/."$i"
        continue
    done

}

function doIt(){
    linkFiles "${BASIC_DOTFILES[@]}"
    if [$MAC_OS]; then
        linkFiles "${GUI_DOTFILES[@]}"
    fi
    if [ $ARCH_OS ]; then
        linkFiles "${ALL_DOTFILES[@]}"
    fi
}

if [ "$FORCE" == true ]; then
	  doIt;
else
	  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	  echo "";
	  if [[ $REPLY =~ ^[Yy]$ ]]; then
		    doIt;
	  fi;
fi;
unset doIt;
