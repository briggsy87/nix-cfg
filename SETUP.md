# Setup Guide - Hyprland + Stylix Integration

## Quick Start (ThinkPad)

### 1. Fix Git Permissions

The git repository is currently owned by root. Fix this:

```bash
# Fix git repository ownership
sudo chown -R briggsy:users /home/briggsy/code/nix-cfg/.git
sudo chown briggsy:users /home/briggsy/code/nix-cfg/flake.lock

# Add new files to git
git add home/core/ home/theme/ home/linux/ home/darwin/
git add flake.nix hosts/thinkpad.nix

# Check what's being added
git status
```

### 2. Update Flake Inputs

```bash
# Pull in Stylix theming system
nix flake lock --update-input stylix
```

### 3. Build Configuration

```bash
# Dry-run to check for errors
sudo nixos-rebuild build --flake .#thinkpad

# If successful, apply the configuration
sudo nixos-rebuild switch --flake .#thinkpad
```

### 4. Reboot

```bash
reboot
```

At the SDDM login screen, select **Hyprland** before logging in.

---

## What's New

### Modular Structure

```
home/
├── core/           # Cross-platform essentials (shell, git, neovim, etc.)
├── theme/          # Stylix theming system
├── linux/          # Hyprland, Waybar, Rofi, GTK theming
└── darwin/         # macOS-specific configs (unchanged)
```

### Key Components

- **Stylix**: Wallpaper-driven color scheme (base16)
- **Hyprland**: Material Design 3 Wayland compositor
- **Waybar**: Styled status bar
- **Rofi**: Application launcher
- **GTK/Qt**: System theming

---

## Customization

### Change Wallpaper

1. Browse wallpapers: `ls ~/Pictures/Wallpapers/`
2. Edit: `nvim home/theme/default.nix`
3. Change: `defaultWallpaper = ./wallpapers/XX.png;` (where XX is a number)
4. Rebuild: `sudo nixos-rebuild switch --flake .#thinkpad`

### Change Colors

Stylix automatically extracts colors from your wallpaper. To use custom colors:

Edit `home/theme/default.nix` and uncomment the `base16Scheme` section.

---

## Hyprland Keybindings

### Applications

- `Super + Return` - Terminal (Alacritty)
- `Super + Space` - App launcher (Rofi)
- `Super + B` - Browser (Firefox)
- `Super + F` - File manager (Thunar)

### Window Management

- `Super + Q` - Close window
- `Super + W` - Toggle floating
- `Super + Shift + F` - Fullscreen
- `Super + h/j/k/l` - Move focus (Vim keys)
- `Super + Shift + h/j/k/l` - Move window

### Workspaces

- `Super + 1-9` - Switch workspace
- `Super + Shift + 1-9` - Move window to workspace

### System

- `Super + Shift + S` - Screenshot
- `Super + L` - Lock screen
- `Super + Shift + E` - Exit Hyprland

---

## Troubleshooting

### Build Fails

```bash
# Show detailed error trace
sudo nixos-rebuild build --flake .#thinkpad --show-trace
```

### Hyprland Won't Start

- Make sure you selected "Hyprland" at SDDM login
- Check logs: `journalctl -u display-manager`

### Revert to GNOME

If you need to go back to GNOME temporarily:

1. Edit `hosts/thinkpad.nix`
2. Comment out the Hyprland section
3. Uncomment the GNOME/GDM section
4. Rebuild

---

## Next Steps

Once you're happy with the setup:

1. Add more wallpapers from the collection
2. Customize keybindings in `home/linux/hyprland/default.nix`
3. Try different Waybar themes
4. Set up Hyprlock (screen locker) with matching theme

---

## Files Modified

- `flake.nix` - Added Stylix input
- `hosts/thinkpad.nix` - Enabled Hyprland
- `home/default.nix` - New modular imports
- `home/shared.nix` - Migrated to core/ modules
- `home/darwin.nix` - Reorganized
- `home/linux.nix` - Replaced with modular setup

## Files Added

- `home/core/*` - Core cross-platform modules
- `home/theme/default.nix` - Stylix configuration
- `home/linux/hyprland/` - Hyprland config
- `home/linux/waybar/` - Status bar
- `home/linux/rofi/` - Launcher
- `home/linux/gtk/` - GTK theming
