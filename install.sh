#!/bin/bash

# Installation script for Omarchy Linux dotfiles setup
# This script installs required packages and sets up dotfiles using stow

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

print_info "Starting dotfiles installation..."
print_info "Dotfiles directory: $DOTFILES_DIR"

# 1. Check for yay
print_info "Checking for yay package manager..."
if ! command_exists yay; then
    print_error "yay is not installed. Please install yay first."
    print_info "You can install it with: git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si"
    exit 1
fi
print_success "yay is installed"

# 2. Install required packages
print_info "Installing required packages: zsh, tmux, claude-code, opencode..."
PACKAGES=("zsh" "tmux" "claude-code" "opencode" "hyprwhspr" "morgen-bin" "vesktop")

for package in "${PACKAGES[@]}"; do
    if yay -Qi "$package" >/dev/null 2>&1; then
        print_info "$package is already installed, skipping..."
    else
        print_info "Installing $package..."
        if yay -S --noconfirm "$package"; then
            print_success "$package installed successfully"
        else
            print_error "Failed to install $package"
            exit 1
        fi
    fi
done

# 3. Install stow
print_info "Checking for stow..."
if ! command_exists stow; then
    print_info "stow is not installed. Installing stow..."
    if yay -S --noconfirm stow; then
        print_success "stow installed successfully"
    else
        print_warning "Failed to install stow via yay, trying pacman..."
        if sudo pacman -S --noconfirm stow; then
            print_success "stow installed successfully via pacman"
        else
            print_error "Failed to install stow"
            exit 1
        fi
    fi
else
    print_success "stow is already installed"
fi

# 4. Install oh-my-zsh
print_info "Checking for oh-my-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_info "oh-my-zsh is not installed. Installing oh-my-zsh..."
    if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended; then
        print_success "oh-my-zsh installed successfully"
    else
        print_error "Failed to install oh-my-zsh"
        exit 1
    fi
else
    print_success "oh-my-zsh is already installed"
fi

# 5. Set zsh as default shell
print_info "Setting zsh as default shell..."
ZSH_PATH=$(which zsh)
if [ -z "$ZSH_PATH" ]; then
    print_error "zsh not found in PATH"
    exit 1
fi

CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
    print_info "Current shell: $CURRENT_SHELL"
    print_info "Changing default shell to: $ZSH_PATH"
    print_warning "This will require your password..."
    if chsh -s "$ZSH_PATH"; then
        print_success "Default shell changed to zsh"
        print_info "Note: The shell change will take effect on your next login"
    else
        print_error "Failed to change default shell"
        print_warning "You may need to run this manually: chsh -s $ZSH_PATH"
    fi
else
    print_success "zsh is already the default shell"
fi

# 6. Stow dotfiles
print_info "Setting up dotfiles with stow..."
cd "$DOTFILES_DIR"

# List of directories to stow
STOW_DIRS=("home" "hypr" "local" "mise" "nvim" "tmux" "tmux-sessionizer" "waybar")

for dir in "${STOW_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        print_info "Stowing $dir..."
        if stow -v -t ~ "$dir" 2>&1; then
            print_success "$dir stowed successfully"
        else
            print_warning "Failed to stow $dir (may already be linked or have conflicts)"
        fi
    else
        print_warning "Directory $dir does not exist, skipping..."
    fi
done

print_success "Installation complete!"
print_info "You may need to log out and log back in for the shell change to take effect."

