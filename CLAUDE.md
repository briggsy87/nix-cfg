# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a **multi-platform Nix configuration** supporting both **nix-darwin** (macOS) and **NixOS** (Linux) using Nix flakes and home-manager. The repository is designed to be platform-agnostic, sharing as much configuration as possible between macOS and Linux systems while keeping platform-specific settings separate.

**Current hosts:**
- `m4pro`: macOS M4 Pro (aarch64-darwin) with Aerospace tiling WM
- `thinkpad`: ThinkPad T14 Gen 1 (x86_64-linux) with XFCE desktop

## Architecture

### Flake Structure

- **`flake.nix`**: Main entry point with centralized host configuration
  - `hosts` attribute set defines all machines with their `system`, `username`, and `platform`
  - `mkSystem` helper function generates appropriate configurations based on platform
  - Outputs both `darwinConfigurations` and `nixosConfigurations`
  - **Important**: Set `username` for each host before first use
  - **Easy to extend**: Just add a new entry to `hosts` and create the corresponding file in `hosts/`

### Host Configurations (`hosts/`)

Host-specific system-level settings. Each file receives `hostname` and `username` as arguments.

- **`hosts/m4pro.nix`**: nix-darwin configuration for macOS
  - TouchID for sudo
  - macOS system defaults (dock, finder, keyboard)
  - Enables Aerospace (disables Homebrew)

- **`hosts/thinkpad.nix`**: NixOS configuration for Linux
  - **Imports `/etc/nixos/hardware-configuration.nix`** (critical - contains disk/LUKS/hardware settings)
  - Bootloader (systemd-boot) with latest kernel
  - Networking (NetworkManager)
  - Desktop environment (GNOME + GDM)
  - Audio (PipeWire)
  - User account creation
  - Docker enabled
  - System state version: 25.05

### Home Manager Structure (`home/`)

User environment configuration managed declaratively. This is where most cross-platform magic happens.

- **`home/default.nix`**: Entry point
  - Accepts `platform` parameter ("darwin" or "nixos")
  - Imports `shared.nix` + platform-specific module
  - Sets home-manager `stateVersion`

- **`home/shared.nix`**: Cross-platform configuration (90% of config)
  - Core CLI tools (neovim, ripgrep, fd, fzf, bat, eza, etc.)
  - Git tools (lazygit, gitui, delta)
  - Languages (Node.js, Python, Terraform)
  - **All LSP servers and formatters via Nix** (no Mason!)
  - Neovim with full plugin stack
  - Zsh + Starship + direnv
  - **Important**: Set `programs.git.userName` and `userEmail`

- **`home/darwin.nix`**: macOS-only packages and configs
  - Aerospace (tiling window manager)
  - Karabiner Elements (keyboard remapping)
  - Terminals (Ghostty, Alacritty)
  - Terminal multiplexers (tmux, zellij)
  - Colima (container runtime)
  - Dotfiles: aerospace.toml, karabiner.json, ghostty/config

- **`home/linux.nix`**: Linux-only packages and configs
  - Alacritty terminal
  - tmux
  - Docker Compose
  - System utilities (htop, pciutils, usbutils)
  - Placeholder for future Hyprland/Wayland setup

### Configuration Management Philosophy

All dotfiles are managed **declaratively** via `xdg.configFile`:
- Source files live in `home/` directory (e.g., `nvim/init.lua`, `aerospace.toml`)
- They get copied to `~/.config/` during rebuild
- **Never edit files in `~/.config/` directly** - always edit source files in this repo
- Changes take effect after running rebuild command

### Neovim Philosophy

Neovim uses a **modular, lazy-loaded architecture** managed through Nix + lazy.nvim:

**Structure:**
```
home/nvim/
├── init.lua                 # Bootstrap lazy.nvim
├── lua/
│   ├── config/             # Core configuration
│   │   ├── options.lua     # Editor settings
│   │   ├── keymaps.lua     # General keybindings
│   │   └── autocmds.lua    # Autocommands (transparency, LSP)
│   └── plugins/            # One file per plugin
│       ├── colorscheme.lua
│       ├── telescope.lua
│       ├── treesitter.lua
│       ├── lsp.lua
│       ├── none-ls.lua     # Formatters/linters
│       ├── completion.lua
│       ├── oil.lua
│       └── git.lua
```

**Key principles:**
- **lazy.nvim** for plugin management and lazy loading
- **Modular config** - each plugin in its own file for maintainability
- **Nix-managed plugins** - all plugins installed via `pkgs.vimPlugins` (offline-first)
- **Nix-managed tools** - LSP servers, formatters, linters as Nix packages
- **Neovim 0.11+ native LSP API** (modern, no nvim-lspconfig dependency)
- **none-ls.nvim** for external formatters/linters
- **Transparency enabled** to match terminal (Ghostty 50% opacity)
- **Dracula theme** active with alternative purple/dark themes available

**Stack:** lazy.nvim + Telescope + Treesitter + Native LSP + nvim-cmp + none-ls + oil.nvim + gitsigns

**📖 See `docs/vim.md` for comprehensive documentation:**
- Modular configuration structure
- Complete keybindings reference
- How to add/modify plugins
- LSP configuration details
- Workflows and tips

## Common Commands

### Build and Apply Configuration

**macOS:**
```bash
# First time setup (requires experimental features enabled)
# If nix-command/flakes not enabled, run:
# mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

nix run nix-darwin -- switch --flake .#m4pro

# Subsequent updates
darwin-rebuild switch --flake .#m4pro

# Dry run (check for errors without applying)
darwin-rebuild build --flake .#m4pro
```

**NixOS:**
```bash
# Apply configuration
sudo nixos-rebuild switch --flake .#thinkpad

# Dry run
sudo nixos-rebuild build --flake .#thinkpad
```

### Managing Flake Dependencies

```bash
# Update all inputs (nixpkgs, darwin, home-manager)
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Show current flake metadata
nix flake metadata
```

### Formatting

```bash
# Format all .nix files in repository
nix fmt
```

### Garbage Collection

```bash
# Clean up old generations
nix-collect-garbage -d

# macOS: Also clean darwin generations
sudo nix-collect-garbage -d

# Optimize Nix store
nix store optimise
```

## Development Workflow

### Adding a New Host

1. **Add entry to `flake.nix`:**
   ```nix
   hosts = {
     # ... existing
     new-machine = {
       system = "x86_64-linux";
       username = "kyle";
       platform = "nixos";
     };
   };
   ```

2. **Create host config file:**
   - Copy similar host from `hosts/`
   - Customize hardware, timezone, system settings
   - File must accept `hostname` and `username` arguments

3. **Apply:**
   ```bash
   sudo nixos-rebuild switch --flake .#new-machine
   ```

### Adding Packages

- **Cross-platform**: Add to `home.packages` in `home/shared.nix`
- **Platform-specific**: Add to `home/darwin.nix` or `home/linux.nix`
- For LSPs/formatters: Also configure in `home/nvim/init.lua`

### Adding Dotfiles

1. Create config file in `home/` directory
2. Add to `xdg.configFile` in appropriate file:
   ```nix
   xdg.configFile."app/config.conf".text = builtins.readFile ./app-config.conf;
   ```
3. Rebuild to apply

### Testing Changes

1. Make edits to `.nix` files or dotfiles
2. Test with dry run: `darwin-rebuild build --flake .` or `sudo nixos-rebuild build --flake .`
3. If successful, apply: `darwin-rebuild switch --flake .` or `sudo nixos-rebuild switch --flake .`
4. Configuration errors prevent activation (safe)

## Key Integrations

### macOS-Specific

- **Aerospace**: Tiling window manager using "hyper" key
  - Hyper = Cmd+Ctrl+Opt+Shift (configured via Karabiner)
  - Workspace switching: hyper+[1-9]
  - Window movement: hyper+hjkl
  - Config: `home/aerospace.toml`

- **Karabiner Elements**: Keyboard remapping for hyper key
  - Config: `home/karabiner.json`
  - Requires permissions grant after first install

- **Terminals**: Ghostty (primary) and Alacritty (fallback)
  - Configs: `home/ghostty/config`, `home/alacritty.toml`

### Cross-Platform

- **Direnv**: Automatically loads `.envrc` files with `nix-direnv` integration
  - Essential for per-project Nix shells
  - Works seamlessly on both platforms

- **Git**: Unified configuration with delta diff viewer
  - Set personal info in `home/shared.nix`

## Important Notes

### First-Time Setup Checklist

Before running rebuild on a new host:

1. ✅ Set `username` in `flake.nix` for your host
2. ✅ Set `git.userName` and `git.userEmail` in `home/shared.nix`
3. ✅ Set `time.timeZone` in `hosts/thinkpad.nix` (Linux only)
4. ✅ For NixOS: Merge hardware configuration into host file

### Platform Detection

The configuration uses the `platform` parameter passed from `flake.nix`:
- `platform == "darwin"` for macOS
- `platform == "nixos"` for Linux
- This is set per-host in the `hosts` attribute set

### Dotfile Management

- Source of truth: Files in `home/` directory
- Applied to: `~/.config/` after rebuild
- Never manually edit `~/.config/` - changes will be overwritten
- Always edit source files and rebuild

### Adding New Platforms

To add support for a new platform (e.g., `nixos-wsl`):
1. Add new platform-specific module in `home/`
2. Update `home/default.nix` import logic
3. Add hosts with new platform type in `flake.nix`
