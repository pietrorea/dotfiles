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

function ensureCopyDir() {
    local src="$1"
    local dest="$2"

    if [[ ! -d "$src" ]]; then
        echo "Source dir not found, skipping: $src"
        return
    fi

    mkdir -p "$(dirname "$dest")"
    rm -rf "$dest"
    cp -R "$src" "$dest"
    echo "Copied $src -> $dest"
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
EXT_LIST="${VSCODE_SRC_DIR}/extensions.txt"
LOCAL_THEME_SRC="${VSCODE_SRC_DIR}/local_extensions/xcode-midnight-2022"
case "$OS_NAME" in
  Darwin)
    CODE_USER_DIR="$HOME/Library/Application Support/Code/User"
    CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
    CODE_EXT_DIR="$HOME/.vscode/extensions"
    CURSOR_EXT_DIR="$HOME/Library/Application Support/Cursor/User/globalStorage/extensions"
    ;;
  Linux)
    CODE_USER_DIR="$HOME/.config/Code/User"
    CURSOR_USER_DIR="$HOME/.config/Cursor/User"
    CODE_EXT_DIR="$HOME/.vscode/extensions"
    CURSOR_EXT_DIR="$HOME/.cursor/extensions"
    ;;
  *)
    CODE_USER_DIR=""
    CURSOR_USER_DIR=""
    CODE_EXT_DIR=""
    CURSOR_EXT_DIR=""
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

# Copy local VS Code/Cursor theme extension (xcode-midnight-2022) if present
if [[ -d "$LOCAL_THEME_SRC" ]]; then
    if [[ -n "$CODE_EXT_DIR" ]]; then
        ensureCopyDir "$LOCAL_THEME_SRC" "${CODE_EXT_DIR}/xcode-midnight-2022"
    fi
    if [[ -n "$CURSOR_EXT_DIR" ]]; then
        ensureCopyDir "$LOCAL_THEME_SRC" "${CURSOR_EXT_DIR}/xcode-midnight-2022"
    fi
fi

# Install extensions if editors are on PATH
if [[ -f "$EXT_LIST" ]]; then
  if command -v code >/dev/null 2>&1; then
    echo "Installing VS Code extensions from ${EXT_LIST}"
    xargs -n1 code --install-extension < "$EXT_LIST"
  else
    echo "code not found on PATH; skipping VS Code extensions"
  fi

  if command -v cursor >/dev/null 2>&1; then
    echo "Installing Cursor extensions from ${EXT_LIST}"
    xargs -n1 cursor --install-extension < "$EXT_LIST"
  else
    echo "cursor not found on PATH; skipping Cursor extensions"
  fi
fi