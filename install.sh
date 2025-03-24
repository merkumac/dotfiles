#!/bin/bash

# We will exit whenever the command exits with a non-zero status, so basically
# on any failure
set -e

# Script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$SCRIPT_DIR"

# Configuration map of source:target paths
DOTFILES=(
    "configs/.zshrc:$HOME/.zshrc"
    "configs/ghostty/config:$HOME/.config/ghostty/config"
)

# Default mode is install
UNINSTALL=false
SKIP_BACKUP=false

# Process command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --uninstall)
      UNINSTALL=true
      shift
      ;;
    --skip-backup)
      SKIP_BACKUP=true
      shift
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo "Options:"
      echo "  --uninstall      Remove symlinks and restore backups if available"
      echo "  --skip-backup    Don't create backups of existing files"
      echo "  --help           Display this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

if [ "$UNINSTALL" = true ]; then
    echo "Uninstalling dotfiles symlinks..."

    for entry in "${DOTFILES[@]}"; do
        TARGET="$(echo "$entry" | cut -d':' -f2)"

        if [ -L "$TARGET" ]; then
            echo "Removing symlink: $TARGET"
            rm "$TARGET"

            # Check if backup exists and restore it
            if [ -e "$TARGET.bak" ]; then
                echo "Restoring backup from $TARGET.bak"
                mv "$TARGET.bak" "$TARGET"
            else
                echo "No backup found for $TARGET"
            fi
        else
            echo "$TARGET is not a symlink managed by this script. Skipping."
        fi
    done

    echo "Uninstall complete! Dotfiles symlinks have been removed."
else
    echo "Setting up symlinks for dotfiles..."

    # Create symlinks
    for entry in "${DOTFILES[@]}"; do
        SOURCE="$DOTFILES_ROOT/$(echo "$entry" | cut -d':' -f1)"
        TARGET="$(echo "$entry" | cut -d':' -f2)"

        # Make sure the source file exists
        if [ ! -e "$SOURCE" ]; then
            echo "Warning: Source file $SOURCE does not exist. Skipping."
            continue
        fi

        # Create target directory if it doesn't exist
        TARGET_DIR="$(dirname "$TARGET")"
        mkdir -p "$TARGET_DIR"

        # Handle existing files at the target location
        if [ -e "$TARGET" ]; then
            if [ -L "$TARGET" ]; then
                echo "$TARGET already exists as a symlink. Updating..."
                rm "$TARGET"
            else
                if [ "$SKIP_BACKUP" = true ]; then
                    echo "$TARGET exists. Overwriting without backup (--skip-backup used)."
                    rm -rf "$TARGET"
                else
                    echo "$TARGET exists and is not a symlink. Backing up to $TARGET.bak..."
                    mv "$TARGET" "$TARGET.bak"
                fi
            fi
        fi

        # Create the symlink
        ln -sf "$SOURCE" "$TARGET"
        echo "Linked $SOURCE -> $TARGET"
    done

    echo "Dotfiles setup complete!"
fi
