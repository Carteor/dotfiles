#!/bin/bash
# install.sh

# Create necessary directories
# mkdir -p ~/.config

# Symlink nvim
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# Symlink bash configs
ln -sf ~/dotfiles/bash/.bashrc ~/.bashrc
ln -sf ~/dotfiles/bash/.bash_profile ~/.bash_profile

echo "Dotfiles installed!"
