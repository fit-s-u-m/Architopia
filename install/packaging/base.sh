# Install all base packages
mapfile -t packages < <(grep -v '^#' "$OMARCHY_INSTALL/omarchy-base.packages" | grep -v '^$')
sudo pacman -S --noconfirm --needed "${packages[@]}"


# Install all aur packages
mapfile -t aur_packages < <(grep -v '^#' "$OMARCHY_INSTALL/omarchy-base.aurPackages" | grep -v '^$')

yay -S --noconfirm --needed "${aur_packages[@]}"
