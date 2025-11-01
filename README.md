# Multi-Platform Nix Configuration

A unified, declarative system configuration for macOS (nix-darwin) and NixOS (Linux) using Nix flakes and home-manager.

## 🎯 Design Philosophy

- **Platform-agnostic**: Share as much configuration as possible between macOS and Linux
- **Declarative**: All dotfiles and packages managed through Nix
- **Modular**: Easy to add new hosts or customize per-machine settings
- **Reproducible**: Same tools and environment across all machines

## 📁 Repository Structure

```
.
├── flake.nix              # Main entry point - defines all hosts
├── hosts/
│   ├── m4pro.nix          # macOS M4 Pro configuration
│   └── thinkpad.nix       # ThinkPad T14 NixOS configuration
└── home/
    ├── default.nix        # Entry point for home-manager
    ├── shared.nix         # Cross-platform packages & configs
    ├── darwin.nix         # macOS-specific (Aerospace, Karabiner, etc.)
    ├── linux.nix          # Linux-specific configs
    ├── nvim/
    │   └── init.lua       # Neovim configuration
    ├── aerospace.toml     # Aerospace window manager (macOS)
    ├── karabiner.json     # Karabiner Elements (macOS)
    ├── alacritty.toml     # Alacritty terminal
    ├── ghostty/config     # Ghostty terminal (macOS)
    ├── tmux/tmux.conf     # Tmux multiplexer
    └── zellij/config.kdl  # Zellij multiplexer
```

## 🚀 Quick Start

### Initial Setup

#### Prerequisites

**macOS:**
```bash
# Install Nix (multi-user installation recommended)
sh <(curl -L https://nixos.org/nix/install)

# Or use Determinate Systems installer (recommended)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

**NixOS:**
Nix is already installed! Just ensure you have Git:
```bash
nix-shell -p git
```

#### Clone and Configure

1. **Clone this repository:**
   ```bash
   git clone <your-repo-url> ~/nix-config
   cd ~/nix-config
   ```

2. **Configure your host in `flake.nix`:**
   ```nix
   hosts = {
     m4pro = {
       system = "aarch64-darwin";
       username = "your-mac-username";  # ← Change this (output of `whoami`)
       platform = "darwin";
     };
     thinkpad = {
       system = "x86_64-linux";
       username = "your-linux-username";  # ← Change this
       platform = "nixos";
     };
   };
   ```

3. **Set your Git identity in `home/shared.nix`:**
   ```nix
   programs.git = {
     userName = "Your Name";
     userEmail = "you@example.com";
   };
   ```

4. **Set your timezone in `hosts/thinkpad.nix` (for Linux):**
   ```nix
   time.timeZone = "America/Los_Angeles";  # ← Change this
   ```

### Apply Configuration

#### macOS (nix-darwin)

First-time setup:
```bash
# Install nix-darwin
nix run nix-darwin -- switch --flake ~/nix-config#m4pro

# Subsequent updates
darwin-rebuild switch --flake ~/nix-config#m4pro
```

#### NixOS (Linux)

**Important:** `hosts/thinkpad.nix` imports `/etc/nixos/hardware-configuration.nix` which must exist on your system. This file contains your hardware-specific settings (disk partitions, LUKS encryption, kernel modules, etc.).

First-time setup:
```bash
# The hardware-configuration.nix should already exist from your initial NixOS install
# It's located at /etc/nixos/hardware-configuration.nix

# Apply configuration
sudo nixos-rebuild switch --flake ~/nix-config#thinkpad
```

Subsequent updates:
```bash
sudo nixos-rebuild switch --flake ~/nix-config#thinkpad
```

## 🔧 Common Commands

### Building & Applying

```bash
# macOS
darwin-rebuild switch --flake .#m4pro
darwin-rebuild build --flake .#m4pro  # Dry run

# NixOS
sudo nixos-rebuild switch --flake .#thinkpad
sudo nixos-rebuild build --flake .#thinkpad  # Dry run
```

### Updating Dependencies

```bash
# Update all flake inputs (nixpkgs, home-manager, etc.)
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Show what would update
nix flake metadata
```

### Formatting

```bash
# Format all .nix files
nix fmt
```

### Garbage Collection

```bash
# Remove old generations and cleanup
nix-collect-garbage -d

# macOS: Also delete old darwin generations
sudo nix-collect-garbage -d

# Optimize Nix store
nix store optimise
```

### Listing Generations

```bash
# macOS
darwin-rebuild --list-generations

# NixOS
sudo nixos-rebuild --list-generations
```

## 🛠️ Customization

### Adding a New Host

1. Add entry to `hosts` in `flake.nix`:
   ```nix
   hosts = {
     # ... existing hosts
     new-machine = {
       system = "x86_64-linux";  # or "aarch64-darwin"
       username = "your-username";
       platform = "nixos";  # or "darwin"
     };
   };
   ```

2. Create host configuration file:
   ```bash
   cp hosts/thinkpad.nix hosts/new-machine.nix
   # Edit as needed
   ```

3. Apply:
   ```bash
   sudo nixos-rebuild switch --flake .#new-machine
   # or for macOS:
   darwin-rebuild switch --flake .#new-machine
   ```

### Adding Packages

Edit `home/shared.nix` for cross-platform packages, or `home/darwin.nix` / `home/linux.nix` for platform-specific ones:

```nix
home.packages = with pkgs; [
  # Add your package here
  my-new-package
];
```

### Adding Dotfiles

1. Create the config file in `home/` directory
2. Reference it in the appropriate file:
   ```nix
   xdg.configFile."app/config.conf".text = builtins.readFile ./app-config.conf;
   ```

## 🧰 Installed Tools

### Core Development
- **Editors**: Neovim with LSP, Telescope, Treesitter
- **Shell**: Zsh with Starship prompt, zoxide, fzf
- **Git**: lazygit, gitui, delta
- **Languages**: Node.js 22, Python 3.13, Terraform

### LSP & Formatters (via Nix)
- Python: pyright, ruff, black, isort
- JavaScript/TypeScript: tsserver, prettier
- Terraform: terraform-ls, tflint
- YAML, JSON, Bash, Lua, Dockerfile support

### Terminal Tools
- **TUI**: yazi, ranger, btop, lazydocker
- **Search**: ripgrep, fd, fzf
- **Utilities**: bat, eza, jq, yq

### Platform-Specific

**macOS:**
- Aerospace (tiling window manager)
- Karabiner Elements (keyboard remapping)
- Ghostty & Alacritty (terminals)
- Colima (container runtime)

**Linux:**
- XFCE (minimal desktop - customizable)
- Docker
- NetworkManager

## 📝 Post-Install Steps

### Install Claude Code

Claude Code is not yet in nixpkgs, so install manually:

```bash
# Install
curl -fsSL https://anthropic.sh | sh

# Authenticate
claude auth login
```

### macOS Additional Setup

1. **Configure Karabiner for Hyper key:**
   - Open Karabiner Elements
   - Grant necessary permissions in System Preferences
   - Configuration is already in `karabiner.json`

2. **Start Aerospace:**
   ```bash
   aerospace reload-config
   ```

3. **Grant terminal permissions:**
   - System Preferences → Privacy & Security → Full Disk Access
   - Add your terminal emulator

### Linux Additional Setup

1. **Connect to WiFi:**
   ```bash
   nmtui  # NetworkManager TUI
   ```

2. **Configure display/monitors:**
   ```bash
   xrandr  # For X11
   ```

## 🔄 Workflow

### Making Changes

1. Edit configuration files
2. Test build: `darwin-rebuild build --flake .` or `sudo nixos-rebuild build --flake .`
3. Apply: `darwin-rebuild switch --flake .` or `sudo nixos-rebuild switch --flake .`
4. Commit changes: `git add . && git commit -m "feat: description"`

### Syncing Between Machines

```bash
# Pull latest changes
git pull

# Update and apply
nix flake update
darwin-rebuild switch --flake .  # or nixos-rebuild
```

## 🐛 Troubleshooting

### "error: unable to download"
```bash
# Clear download cache
rm -rf ~/.cache/nix
```

### "error: getting status of '/nix/store/...': No such file or directory"
```bash
nix store repair
```

### Home-manager conflicts
```bash
# Remove conflicting files
rm ~/.config/nvim/init.lua  # example
```

### macOS: "command not found" after install
```bash
# Reload shell
exec zsh
```

## 📚 Resources

- [Nix Manual](https://nixos.org/manual/nix/stable/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [nix-darwin Manual](https://daiderd.com/nix-darwin/manual/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/)

## 🔒 Security & Secrets

This repository is designed to be **publicly shared on GitHub**. It contains no secrets.

For managing secrets (SMB shares, API keys, etc.), see [SECRETS.md](SECRETS.md) for a complete guide on using **sops-nix**.

### Before Committing

Always verify no secrets are included:
```bash
# Search for potential secrets
grep -rE "(password|secret|key|token)" . --include="*.nix"

# Review changes
git diff
```

## 📄 License

This configuration is free to use and modify for personal use.
