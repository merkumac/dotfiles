#!/usr/bin/env bash
set -e

# before brew install neovim git ripgrep llvm pyright ruff tmux

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$HOME/.config/nvim"

#      From                ->  To
ln -sf "$DOTFILES/init.lua"    "$HOME/.config/nvim/init.lua"
ln -sf "$DOTFILES/.zshrc"      "$HOME/.zshrc"

echo "symlinks created"
