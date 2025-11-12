#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title New Notes window
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

/Applications/Alacritty.app/Contents/MacOS/alacritty msg create-window --working-directory ~/Documents/journal -e zsh -ic 'vv' && aeroSpace move-node-to-workspace N
