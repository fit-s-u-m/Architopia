#!/bin/bash
set -euo pipefail

echo "==> Installing AUR packages with yay..."

# Make sure we are NOT root (yay will fail otherwise)
if [[ "$EUID" -eq 0 ]]; then
  echo "❌ Do not run this script as root."
  echo "👉 Run it as your normal user after login."
  exit 1
fi

# Sanity check
if ! command -v yay &>/dev/null; then
  echo "❌ yay not found. Something went wrong."
  exit 1
fi

# Update repos + system first (optional but recommended)
yay -Syu --noconfirm

# AUR packages
AUR_PACKAGES=(
  blueberry
  sesh-bin
  zen-browser-bin
  wlogout
)

# Install
yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"

echo "✅ AUR packages installed successfully."
