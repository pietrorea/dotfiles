#!/bin/bash

defaults write com.apple.finder AppleShowAllFiles -bool true

defaults write NSGlobalDomain AppleShowAllExtensions -bool true

defaults write com.apple.finder ShowStatusBar -bool true

defaults write com.apple.finder ShowPathbar -bool true

defaults write com.app./le.finder FXEnableExtensionChangeWarning -bool false

defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

