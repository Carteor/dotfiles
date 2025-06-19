#!/bin/bash

set -e

echo "Setting up dotfiles..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect package manager
get_package_manager() {
    if command_exists apt; then
        echo "apt"
    elif command_exists yum; then
        echo "yum"
    elif command_exists dnf; then
        echo "dnf"
    elif command_exists pacman; then
        echo "pacman"
    elif command_exists brew; then
        echo "brew"
    else
        echo "unknown"
    fi
}

PACKAGE_MANAGER=$(get_package_manager)

# Install system dependencies
case $PACKAGE_MANAGER in
    "apt")
        echo "Updating package lists..."
        sudo apt update || echo "Warning: apt update failed, continuing anyway..."
        sudo apt install -y curl wget unzip fontconfig
        ;;
    "yum"|"dnf")
        sudo $PACKAGE_MANAGER install -y curl wget unzip fontconfig
        ;;
    "pacman")
        sudo pacman -S --noconfirm curl wget unzip fontconfig
        ;;
    "brew")
        brew install curl wget unzip
        ;;
esac

# Install JetBrains Mono Nerd Font
echo "Installing JetBrains Mono Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

if [ ! -f "$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]; then
    echo "Downloading JetBrains Mono Nerd Font..."
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip"
    TEMP_DIR=$(mktemp -d)

    if wget -O "$TEMP_DIR/JetBrainsMono.zip" "$FONT_URL"; then
        unzip -o "$TEMP_DIR/JetBrainsMono.zip" -d "$FONT_DIR/"

        # Clean up
        rm -rf "$TEMP_DIR"

        # Refresh font cache
        fc-cache -fv
        echo "JetBrains Mono Nerd Font installed successfully!"
    else
        echo "Failed to download font, skipping..."
        rm -rf "$TEMP_DIR"
    fi
else
    echo "JetBrains Mono Nerd Font already installed"
fi

# Install Starship
if ! command_exists starship; then
    echo "Installing Starship..."
    if curl -sS https://starship.rs/install.sh | sh -s -- --yes; then
        echo "Starship installed successfully!"
    else
        echo "Failed to install Starhsip"
        exit 1
    fi
else
    echo "Starship already installed"
fi

# Install fzf
if ! command_exists fzf; then
    echo "Installing fzf..."
    case $PACKAGE_MANAGER in
        "apt")
            sudo apt install -y fzf
            ;;
        "yum")
            sudo yum install -y fzf
            ;;
        "dnf")
            sudo dnf install -y fzf
            ;;
        "pacman")
            sudo pacman -S --noconfirm fzf
            ;;
        "brew")
            brew install fzf
            ;;
        *)
            echo "Installing fzf via git..."
            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
            ~/.fzf/install --key-bindings --completion --no-update-rc
            ;;
    esac
else
    echo "fzf already installed"
fi

# Install powerline via pipx
if ! command_exists pipx; then
    echo "Installing pipx..."
    if command_exists apt; then
        sudo apt install -y pipx
    else
        python3 -m pip install --user pipx
    fi
    pipx ensurepath
fi

if ! command_exists powerline-daemon; then
    echo "Installing powerline via pipx..."
    pipx install powerline-status
fi

# Install TPM
if [ ! -d ~/.tmux/plugins/tpm ]; then
	echo "Installing TPM (Tmux Plugin Manager)..."
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Create necessary directories
mkdir -p ~/.config

# Backup existing configs (optional)
backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
if [ -f ~/.bashrc ] && [ ! -L ~/.bashrc ]; then
    echo "Backing up existing configs to $backup_dir"
    mkdir -p "$backup_dir"
    cp ~/.bashrc "$backup_dir/" 2>/dev/null || true
    cp ~/.tmux.conf "$backup_dir/" 2>/dev/null || true
    cp -r ~/.config/nvim "$backup_dir/" 2>/dev/null || true
    cp -r ~/.config/starship.toml "$backup_dir/" 2>/dev/null || true
fi

# Remove existing files/links
rm -f ~/.bashrc ~/.tmux.conf ~/.config/starship.toml
rm -rf ~/.config/nvim

# Verify dotfiles directory exists
if [ ! -d ~/dotfiles ]; then
    echo "Error: ~/dotfiles directory not found!"
    echo "Please clone your dotfiles repository to ~/dotfiles first"
    exit 1
fi

# Create symlinks
echo "Linking nvim config..."
if [ -d ~/dotfiles/nvim ]; then
    ln -sf ~/dotfiles/nvim ~/.config/nvim
    echo "✓ Neovim config linked"
else
    echo "Warning: ~/dotfiles/nvim not found"
fi

echo "Linking tmux config..."
if [ -f ~/dotfiles/tmux/.tmux.conf ]; then
    ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
    echo "✓ Tmux config linked"
else
    echo "Warning: ~/dotfiles/tmux/.tmux.conf not found"
fi

echo "Linking bash config..."
if [ -f ~/dotfiles/bash/.bashrc ]; then
    ln -sf ~/dotfiles/bash/.bashrc ~/.bashrc
    echo "✓ Bash config linked"
else
    echo "Warning: ~/dotfiles/bash/.bashrc not found"
fi

echo "Linking starship config..."
if [ -f ~/dotfiles/starship/starship.toml ]; then
    ln -sf ~/dotfiles/starship/starship.toml ~/.config/starship.toml
    echo "✓ Starship config linked"
else
    echo "Warning: ~/dotfiles/starship/starship.toml not found"
fi 

echo "Dotfiles installed successfully!"
echo "Please restart your terminal or run: source ~/.bashrc"
