#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

SUFFIX='##### Added by my dotfiles' 
SEARCH_PATTERN=".*${SUFFIX}"
TEXT_TO_ADD="source ${DIR}/shell/source.sh ${SUFFIX}" 

function addOrUpdate() {
    if [[ ! -f "$1" ]]; then
        echo File "$1" not found
        return
    fi

    echo Updating "$1"

    if grep -q "${SUFFIX}" "$1"; then
        sed -i.orig "s_${SEARCH_PATTERN}_${TEXT_TO_ADD}_" "$1"
    else
        echo
        echo "${TEXT_TO_ADD}" >> "$1"
    fi
}

# Source .bash_profile

addOrUpdate "$HOME/.bash_profile"

# Source .zshrc

addOrUpdate "$HOME/.zshrc"

# Copy config files

read -p "Existing dotfiles in your home directory will be overwritten. Are you sure? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
# Use rsync once there are more than a couple of files.
    cp .gitconfig ~;
    cp .gitignore_gloabl ~;
fi;


