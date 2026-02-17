#!/usr/bin/env bash

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.config/tmux"
mkdir -p "$HOME/.config/gh" #GitHub CLI

# sudo pacman -Sy stow zsh python-pyusb podman hyprland

stow --dotfiles -t "$HOME" .
