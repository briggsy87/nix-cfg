# Keybindings & Commands Cheatsheet

Quick reference for all keybindings and shortcuts in this NixOS configuration.

**Note:** `$modifier` = `Super` (Windows key) throughout this document.

---

## Hyprland Window Manager

### Applications
| Key | Action |
|-----|--------|
| `Super + Return` | Open Alacritty terminal |
| `Super + T` | Open Ghostty terminal |
| `Super + Shift + Return` | Open Kitty terminal (best for image previews) |
| `Super + B` | Open Firefox browser |
| `Super + F` | Open Thunar file manager |
| `Super + Space` | Open Rofi application launcher |

### Window Management
| Key | Action |
|-----|--------|
| `Super + Q` | Kill active window |
| `Super + W` | Toggle floating mode |
| `Super + Shift + F` | Toggle fullscreen |
| `Super + P` | Toggle pseudo-tiling |
| `Super + Shift + I` | Toggle split direction |

### Focus Movement (Vim Keys)
| Key | Action |
|-----|--------|
| `Super + H` | Focus left |
| `Super + L` | Focus right |
| `Super + K` | Focus up |
| `Super + J` | Focus down |

### Focus Movement (Arrow Keys)
| Key | Action |
|-----|--------|
| `Super + Left` | Focus left |
| `Super + Right` | Focus right |
| `Super + Up` | Focus up |
| `Super + Down` | Focus down |

### Move Windows (Vim Keys)
| Key | Action |
|-----|--------|
| `Super + Shift + H` | Move window left |
| `Super + Shift + L` | Move window right |
| `Super + Shift + K` | Move window up |
| `Super + Shift + J` | Move window down |

### Workspaces
| Key | Action |
|-----|--------|
| `Super + 1-9,0` | Switch to workspace 1-10 |
| `Super + Shift + 1-9,0` | Move window to workspace 1-10 |

### Screenshots
| Key | Action |
|-----|--------|
| `Print` | Screenshot selection (open in Swappy editor) |
| `Super + Shift + Print` | Screenshot selection (open in Swappy editor) |

### System & Power Controls
| Key | Action |
|-----|--------|
| `Super + L` | Lock screen (Hyprlock) |
| `Super + Escape` | Open power menu (Lock/Suspend/Logout/Reboot/Shutdown) |
| `Super + Shift + Delete` | Suspend immediately |
| `Super + Shift + E` | Exit Hyprland |
| `Super + Shift + R` | Reload Hyprland config + waybar + wallpaper |

### Mouse Bindings
| Key | Action |
|-----|--------|
| `Super + Left Click` | Move window |
| `Super + Right Click` | Resize window |

### Media Keys
| Key | Action |
|-----|--------|
| `Volume Up/Down` | Adjust volume by 5% |
| `Mute` | Toggle mute |
| `Mic Mute` | Toggle microphone mute |
| `Brightness Up/Down` | Adjust brightness by 5% |
| `Play/Pause` | Toggle media playback |
| `Next/Previous` | Next/previous track |

---

## Waybar (Status Bar)

### Module Clicks
| Module | Action |
|--------|--------|
| Pulseaudio icon | Open Pavucontrol (audio settings) |
| Bluetooth icon | Open Blueman Manager (bluetooth settings) |
| Network icon | Open Network Manager connection editor |

---

## Tmux (Terminal Multiplexer)

**Prefix:** `Ctrl + A`

### Basic Commands
| Key | Action |
|-----|--------|
| `Ctrl + A` then `C` | Create new window |
| `Ctrl + A` then `N` | Next window |
| `Ctrl + A` then `P` | Previous window |
| `Ctrl + A` then `D` | Detach from session |

### Pane Management
| Key | Action |
|-----|--------|
| `Ctrl + A` then `\|` | Split pane vertically |
| `Ctrl + A` then `-` | Split pane horizontally |
| `Ctrl + A` then `H` | Select pane left |
| `Ctrl + A` then `J` | Select pane down |
| `Ctrl + A` then `K` | Select pane up |
| `Ctrl + A` then `L` | Select pane right |

### Sessions
| Key | Action |
|-----|--------|
| `Ctrl + A` then `S` | Choose session/window tree |
| `Ctrl + A` then `R` | Reload tmux config |

### Copy Mode
| Key | Action |
|-----|--------|
| `Ctrl + A` then `[` | Enter copy mode |
| `Y` (in copy mode) | Copy selection to clipboard |
| `Q` (in copy mode) | Exit copy mode |

---

## Ranger (File Manager)

### Navigation
| Key | Action |
|-----|--------|
| `H/J/K/L` | Navigate left/down/up/right |
| `GG` | Go to top |
| `G` | Go to bottom |
| `GH` | Go to home directory |

### File Operations
| Key | Action |
|-----|--------|
| `Enter` | Open file/directory |
| `YY` | Copy (yank) file |
| `DD` | Cut file |
| `PP` | Paste file |
| `Space` | Select file |
| `V` | Select all files |
| `UV` | Unselect all files |
| `:delete` | Delete selected files |

### Preview Controls
| Key | Action |
|-----|--------|
| `ZP` | Toggle preview pane |
| `ZV` | Toggle external preview commands (for images) |
| `ZI` | Toggle image previews |
| `I` | View file in pager |

### Search & Filter
| Key | Action |
|-----|--------|
| `/` | Search files |
| `N` | Next search result |
| `N` (shift) | Previous search result |
| `F` | Find file (fuzzy) |

### Misc
| Key | Action |
|-----|--------|
| `Q` | Quit |
| `R` | Reload directory |
| `ZH` | Toggle hidden files |
| `S` | Open shell in current directory |

---

## Hyprlock & Hypridle (Screen Lock & Idle)

### Auto-lock Timers
- **5 minutes:** Dim screen to 10% brightness
- **10 minutes:** Lock screen (hyprlock)
- **15 minutes:** Turn off display
- **30 minutes:** Suspend system

### Manual Lock Commands
```bash
# Lock screen
hyprlock

# Suspend immediately
systemctl suspend

# Open power menu
power-menu
```

---

## Rofi (Application Launcher)

### Basic Navigation
| Key | Action |
|-----|--------|
| `Arrow Keys` or `Tab` | Navigate items |
| `Enter` | Launch selected application |
| `Escape` | Close Rofi |

### Mode Switching
| Key | Action |
|-----|--------|
| `Shift + Left/Right` | Switch between modes (Apps/Run/Files) |

### Power Menu
| Key | Action |
|-----|--------|
| `Super + Escape` | Open power menu with options: Lock, Suspend, Logout, Reboot, Shutdown |

---

## Lazygit

### Basic Navigation
| Key | Action |
|-----|--------|
| `H/J/K/L` | Navigate panels |
| `1-5` | Jump to panel (Status/Files/Branches/Commits/Stash) |
| `Q` | Quit |

### Files Panel
| Key | Action |
|-----|--------|
| `Space` | Stage/unstage file |
| `A` | Stage/unstage all files |
| `C` | Commit staged files |
| `P` | Pull |
| `Shift + P` | Push |

### Commit Panel
| Key | Action |
|-----|--------|
| `Enter` | View commit files |
| `D` | View diff |
| `R` | Reword commit |
| `E` | Edit commit |

### Branches Panel
| Key | Action |
|-----|--------|
| `Space` | Checkout branch |
| `N` | New branch |
| `M` | Merge into current branch |
| `R` | Rebase onto branch |
| `D` | Delete branch |

### Global Commands
| Key | Action |
|-----|--------|
| `?` | Show help |
| `X` | Open command menu |
| `:` | Execute custom command |
| `Ctrl + R` | Refresh |

---

## Zsh Shell Aliases

### Nix Commands
```bash
nix-build          # Build Nix derivation
nix-shell          # Enter Nix shell environment
nix-store          # Manage Nix store
nix flake update   # Update flake inputs
```

### System Management
```bash
# Rebuild system
sudo nixos-rebuild switch --flake .#thinkpad

# Rebuild and test (don't set as boot default)
sudo nixos-rebuild test --flake .#thinkpad

# Garbage collection
nix-collect-garbage -d
sudo nix-collect-garbage -d

# Optimize nix store
nix store optimise
```

### Common Aliases (if configured)
```bash
ll         # ls -la (detailed list)
la         # ls -A (show hidden)
l          # ls -CF (classify files)
```

---

## Neovim

**Note:** Check your Neovim configuration for specific keybindings. Common defaults include:

### Normal Mode
| Key | Action |
|-----|--------|
| `Space` | Leader key (commonly configured) |
| `Ctrl + N` | Toggle file tree (NvimTree/Oil) |
| `Ctrl + P` | Fuzzy file finder (Telescope) |

### LSP (Language Server Protocol)
| Key | Action |
|-----|--------|
| `Gd` | Go to definition |
| `Gr` | Go to references |
| `K` | Show hover documentation |
| `Leader + R` | Rename symbol |

---

## Git Commands (Terminal)

### Common Git Workflows
```bash
# View status
git status

# Stage and commit
git add .
git commit -m "message"

# Pull and push
git pull
git push

# View log
git log --oneline --graph --all

# Interactive tools
lazygit    # TUI for Git
gitui      # Alternative TUI
```

---

## Systemd User Services

### Common Commands
```bash
# Restart waybar
systemctl --user restart waybar

# View waybar logs
journalctl --user -u waybar -f

# List all user services
systemctl --user list-units
```

---

## Wallpaper & Theme Changes

### Change Wallpaper and Regenerate Theme
```bash
# 1. Replace wallpaper
cp ~/Pictures/new-wallpaper.png ~/code/nix-cfg/home/theme/default-wallpaper.png

# 2. Rebuild system (Stylix will regenerate colors)
sudo nixos-rebuild switch --flake .#thinkpad

# 3. Reload Hyprland config and wallpaper
Super + Shift + R
```

---

## Package Management

### Search for Packages
```bash
# Search nixpkgs
nix search nixpkgs <package-name>

# Example
nix search nixpkgs firefox
```

### Add Packages
Edit the appropriate `.nix` file:
- System-wide: `hosts/thinkpad.nix`
- User packages: `home/shared.nix` (cross-platform) or `home/linux/default.nix`

---

## Tips & Tricks

### Reload Specific Services After Rebuild
```bash
# Reload Hyprland config + waybar + wallpaper
Super + Shift + R

# Or manually:
systemctl --user restart waybar
hyprctl reload
swww img ~/.current-wallpaper
```

### Check Errors
```bash
# View waybar errors
journalctl --user -u waybar -n 50

# View system logs
journalctl -xe

# Test Hyprland config without applying
hyprctl reload
```

### File Locations
- **Hyprland config:** `~/.config/hypr/hyprland.conf`
- **Waybar config:** `~/.config/waybar/config`
- **Rofi config:** `~/.config/rofi/`
- **Ranger config:** `~/.config/ranger/rc.conf`
- **Current wallpaper:** `~/.current-wallpaper`

---

**Last Updated:** 2025-11-02

**Note:** This cheatsheet is automatically managed. Update the source configurations in the `home/` directory, then rebuild to apply changes.
