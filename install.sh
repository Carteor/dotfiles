#!/bin/bash

echo "Setting up dotfiles..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install dependencies
echo "Installing dependencies..."

# Install fzf
if ! command_exists fzf; then
    echo "Installing fzf..."
    if command_exists apt; then
        sudo apt update && sudo apt install -y fzf
    elif command_exists yum; then
        sudo yum install -y fzf
    elif command_exists pacman; then
        sudo pacman -S --noconfirm fzf
    elif command_exists brew; then
        brew install fzf
    else
        echo "Installing fzf via git..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --key-bindings --completion --no-update-rc
    fi
else
    echo "fzf already installed"
fi

# Add other dependencies here as needed
# Example:
# if ! command_exists tmux; then
#     echo "Installing tmux..."
#     sudo apt install -y tmux
# fi

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
fi

# Remove existing files/links
rm -f ~/.bashrc ~/.tmux.conf
rm -rf ~/.config/nvim

# Create symlinks
echo "Linking nvim config..."
ln -sf ~/dotfiles/nvim ~/.config/nvim

echo "Linking tmux config..."
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf

echo "Linking bash config..."
ln -sf ~/dotfiles/bash/.bashrc ~/.bashrc

echo "Dotfiles installed successfully!"
echo "Please restart your terminal or run: source ~/.bashrc"
