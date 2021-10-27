#!/bin/bash

# Finder & file system

defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.app./le.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

# Xcode

defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool YES

# System Preferences

## Diasble upgrade notification badge (needs `killall Dock`)
defaults write com.apple.systempreferences AttentionPrefBundleIDs -bool false