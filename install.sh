#!/bin/bash

set -e   # exit immediately on error

echo "Setting up symlinks for dotfiles..."

DOTFILES=(
    "configs/.zshrc:$HOME/.zshrc"
    "configs/ghostty/config:$HOME/.config/ghostty/config"
)

for entry in "${DOTFILES[@]}"; do
    SOURCE="$HOME/dotfiles/$(echo "$entry" | cut -d':' -f1)"
    TARGET="$(echo "$entry" | cut -d':' -f2)"

    mkdir -p "$(dirname "$TARGET")"

    if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
        echo "$TARGET exists and is not a symlink. Backing up..."
        mv "$TARGET" "$TARGET.bak"
    fi

    ln -sf "$SOURCE" "$TARGET"
    echo "Linked $SOURCE -> $TARGET"
done

echo "dotfiles setup complete"

