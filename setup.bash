#!/usr/bin/env bash

# ==============================================================================
#  SETTINGS
# ==============================================================================
FONT_NAME="JetBrainsMono"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
# This finds the directory where setup.sh is, so you can run it from anywhere
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting Dotfiles Setup...${NC}"

# ==============================================================================
#  1. OS DETECTION & INSTALLATION
# ==============================================================================
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
    FONT_DIR="$HOME/Library/Fonts"
    echo -e "${GREEN}Detected OS: macOS${NC}"
    
    if ! command -v brew &> /dev/null; then
        echo -e "${RED}Homebrew not found! Please install it first: https://brew.sh${NC}"
        exit 1
    fi

    echo -e "${BLUE}Installing packages via Homebrew...${NC}"
    PACKAGES=("neovim" "starship" "ripgrep" "fzf" "alacritty" "gcc" "tmux" "zsh-syntax-highlighting" "zsh-autosuggestions")

    for pkg in "${PACKAGES[@]}"; do
        if ! brew list "$pkg" &>/dev/null; then
            echo "Installing $pkg..."
            brew install "$pkg"
        fi
    done

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
    FONT_DIR="$HOME/.local/share/fonts"
    echo -e "${GREEN}Detected OS: Linux${NC}"
    echo "Please ensure you have installed: neovim, starship, ripgrep, fzf, alacritty, gcc, tmux"
else
    echo "Unknown OS. Exiting."
    exit 1
fi

# ==============================================================================
#  2. FONTS
# ==============================================================================
echo -e "${BLUE}Checking for Nerd Fonts...${NC}"
if [ -d "$FONT_DIR" ] && ls "$FONT_DIR/$FONT_NAME"*Nerd*Font* >/dev/null 2>&1; then
    echo -e "${GREEN}Fonts already installed.${NC}"
else
    echo "Downloading $FONT_NAME..."
    mkdir -p "$FONT_DIR"
    TEMP_DIR=$(mktemp -d)
    curl -L -o "$TEMP_DIR/font.zip" "$FONT_URL"
    unzip -q "$TEMP_DIR/font.zip" -d "$TEMP_DIR"
    mv "$TEMP_DIR"/*.ttf "$FONT_DIR/"
    rm -rf "$TEMP_DIR"
    if [[ "$OS" == "Linux" ]] && command -v fc-cache >/dev/null 2>&1; then fc-cache -fv; fi
    echo -e "${GREEN}Fonts installed!${NC}"
fi

# ==============================================================================
#  3. SYMLINKING (Aggressive Fresh Start)
# ==============================================================================
echo -e "${BLUE}Linking Config Files...${NC}"

link_file() {
    local src="$1"
    local dest="$2"

    # 1. Check if source exists in your repo
    if [ ! -e "$src" ]; then
        echo -e "${RED}ERROR: Source file not found: $src${NC}"
        return
    fi

    # 2. Get Absolute Path (CRITICAL to prevent infinite loops)
    # This ensures the link points to /Users/... not a relative path
    local abs_src
    abs_src=$(cd "$(dirname "$src")" && pwd)/$(basename "$src")

    # 3. Create destination directory if it doesn't exist
    mkdir -p "$(dirname "$dest")"

    # 4. Aggressive Fresh Start:
    # If destination exists (file, directory, or broken link), REMOVE IT.
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        rm -rf "$dest"
    fi

    # 5. Create the fresh link
    ln -s "$abs_src" "$dest"
    echo -e "${GREEN}Linked: $dest -> $abs_src${NC}"
}

# --- Link the files ---
# Using DOTFILES_DIR ensures we are pointing to your repo files
link_file "$DOTFILES_DIR/.zshrc"         "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.aliases"       "$HOME/.aliases"
link_file "$DOTFILES_DIR/.tmux.conf"     "$HOME/.tmux.conf"

# Config subdirectories
link_file "$DOTFILES_DIR/.config/nvim/init.lua"          "$HOME/.config/nvim/init.lua"
link_file "$DOTFILES_DIR/.config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
link_file "$DOTFILES_DIR/.config/starship.toml"           "$HOME/.config/starship.toml"

echo -e "${GREEN}Setup Complete! Restart your terminal.${NC}"
