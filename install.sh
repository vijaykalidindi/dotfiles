#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

# Config mappings: "source_relative_path:target_absolute_path"
CONFIGS=(
    ".tmux.conf:$HOME/.tmux.conf"
    "nvim:$HOME/.config/nvim"
    "kitty:$HOME/.config/kitty"
    "alacritty:$HOME/.config/alacritty"
    "ghostty:$HOME/.config/ghostty"
    "zellij:$HOME/.config/zellij"
)

link_config() {
    local src="$SCRIPT_DIR/$1"
    local target="$2"

    if [ ! -e "$src" ] && [ ! -L "$src" ]; then
        echo "MISSING  $src (not found in repo, skipping)"
        return 1
    fi

    local target_dir
    target_dir="$(dirname "$target")"
    mkdir -p "$target_dir"

    if [ -L "$target" ]; then
        local current
        current="$(readlink "$target")"
        if [ "$current" = "$src" ]; then
            echo "OK       $target -> $src (already linked)"
            return 0
        fi
        echo "BACKUP   $target (symlink to $current) -> ${target}.bak.${TIMESTAMP}"
        mv "$target" "${target}.bak.${TIMESTAMP}"
    elif [ -e "$target" ]; then
        echo "BACKUP   $target -> ${target}.bak.${TIMESTAMP}"
        mv "$target" "${target}.bak.${TIMESTAMP}"
    fi

    ln -s "$src" "$target"
    echo "LINKED   $target -> $src"
}

echo "Installing dotfiles from $SCRIPT_DIR"
echo "---"

for entry in "${CONFIGS[@]}"; do
    src="${entry%%:*}"
    target="${entry#*:}"
    link_config "$src" "$target"
done

echo "---"
echo "Done."
