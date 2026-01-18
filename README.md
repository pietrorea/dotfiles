# dotfiles

My personal configuration and setup scripts. These are how I set up my tools. Use with caution.

## Installation

1. Run `./bootstrap.sh` to ensure prerequisites (zsh, nvm, pnpm) are present. Today it only checks; future versions will auto-install missing pieces.
2. Run `./install.sh` to wire up shell sourcing and copy these tracked files into your home dir (overwriting): `.gitconfig`, `.gitignore_global`, `.vimrc`, `.nvmrc`.
   - Adds a tagged `source shell/source.sh` line to `~/.bashrc` and `~/.zshrc`.
   - Ensures `~/.bash_profile` sources `~/.bashrc` with the same tag.

Over time, the install script will do more, but for now everything else is manual copying/installation. 

## macOS-specific files

- `mac/mac-setup.sh`: tweaks Finder (show hidden files/extensions, status/path bar, column view) and system defaults (Xcode build duration, disable upgrade badge). Run manually on macOS: `bash mac/mac-setup.sh` (it uses `defaults write`, so it’s macOS-only).
- `iterm2/com.googlecode.iterm2.plist`: your iTerm2 preferences export. Import it in iTerm2 via Preferences → General → Preferences → “Load preferences from a custom folder or URL” and point to the `iterm2` directory (or copy into `~/Library/Preferences` if you prefer). 