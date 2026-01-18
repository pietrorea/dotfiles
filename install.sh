#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

SUFFIX='##### Added by my dotfiles' 
SEARCH_PATTERN=".*${SUFFIX}"
OS_NAME="$(uname -s)"

# Add a tagged line to the file (update it if it’s already there).
function ensureLineInFile() {
    local target="$1"
    local text="$2"

    if [[ -z "$text" ]]; then
        echo "No text provided for $target"
        return
    fi

    if [[ ! -f "$target" ]]; then
        echo File "$target" not found
        return
    fi

    echo Updating "$target"

    if grep -q "${SUFFIX}" "$target"; then
        sed -i.orig "s_${SEARCH_PATTERN}_${text}_" "$target"
    else
        echo
        echo "${text}" >> "$target"
    fi
}

# Symlink a file into a target location, creating parent dirs.
function ensureSymlink() {
    local src="$1"
    local dest="$2"

    if [[ ! -f "$src" ]]; then
        echo "Source not found, skipping: $src"
        return
    fi

    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
    echo "Linked $dest -> $src"
}

# Ensure shell config files exist

touch "$HOME/.bash_profile" "$HOME/.bashrc" "$HOME/.zshrc"

# Source .bashrc
BASH_SOURCE_LINE="source ${DIR}/shell/source.sh ${SUFFIX}" 
ensureLineInFile "$HOME/.bashrc" "$BASH_SOURCE_LINE"

# Source .zshrc

ensureLineInFile "$HOME/.zshrc" "$BASH_SOURCE_LINE"

# Ensure .bash_profile sources .bashrc

ensureLineInFile "$HOME/.bash_profile" "source ~/.bashrc ${SUFFIX}"

# Copy config files (.gitconfig, .gitignore_global, .vimrc, .nvmrc)

read -p "Existing .gitconfig, .gitignore_global, .vimrc, and .nvmrc in your home directory will be overwritten. Continue? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
# Use rsync once there are more than a couple of files.
    cp "${DIR}/.gitconfig" ~;
    cp "${DIR}/.gitignore_global" ~;
    cp "${DIR}/.vimrc" ~;
    cp "${DIR}/.nvmrc" ~;
fi;

# Symlink VS Code / Cursor settings and keybindings
VSCODE_SRC_DIR="${DIR}/vscode"
case "$OS_NAME" in
  Darwin)
    CODE_USER_DIR="$HOME/Library/Application Support/Code/User"
    CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
    ;;
  Linux)
    CODE_USER_DIR="$HOME/.config/Code/User"
    CURSOR_USER_DIR="$HOME/.config/Cursor/User"
    ;;
  *)
    CODE_USER_DIR=""
    CURSOR_USER_DIR=""
    echo "Unknown OS (${OS_NAME}); skipping VS Code/Cursor symlinks."
    ;;
esac

if [[ -n "$CODE_USER_DIR" ]]; then
    ensureSymlink "${VSCODE_SRC_DIR}/settings.json" "${CODE_USER_DIR}/settings.json"
    ensureSymlink "${VSCODE_SRC_DIR}/keybindings.json" "${CODE_USER_DIR}/keybindings.json"
fi

if [[ -n "$CURSOR_USER_DIR" ]]; then
    ensureSymlink "${VSCODE_SRC_DIR}/settings.json" "${CURSOR_USER_DIR}/settings.json"
    ensureSymlink "${VSCODE_SRC_DIR}/keybindings.json" "${CURSOR_USER_DIR}/keybindings.json"
fi