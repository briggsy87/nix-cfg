{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # Default wallpaper
  # After setup, you can browse all wallpapers in ~/Pictures/Wallpapers/
  # and update this path to any wallpaper you prefer
  defaultWallpaper = ./default-wallpaper.png;
in
{
  # Stylix - Declarative system-wide theming
  stylix = {
    enable = true;

    # Wallpaper drives the color scheme
    image = defaultWallpaper;

    # Dark theme
    polarity = "dark";

    # Terminal opacity
    opacity.terminal = 1.0;

    # Cursor theme (Bibata Modern Ice)
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    # Font configuration
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };

    # Platform-specific target overrides
    targets = {
      # Cross-platform targets (enabled by default)
      neovim.enable = false;  # Using manual Dracula theme in neovim
      bat.enable = false;      # Using manual Dracula theme in bat
      fzf.enable = true;
      tmux.enable = false;     # Using manual Dracula theme in tmux

      # Darwin-specific
      alacritty.enable = isDarwin;
      kitty.enable = true;

      # Linux-specific - we'll manually theme these for more control (with transparency)
      waybar.enable = false;
      rofi.enable = false;
      hyprland.enable = false;
      hyprlock.enable = false;  # Manual hyprlock config with custom styling
      mako.enable = false;  # Manual mako config with transparency
      gtk.enable = isLinux;
      qt.enable = isLinux;
    } // lib.optionalAttrs isDarwin {
      # ghostty on Darwin if available
      ghostty.enable = true;
    };
  };

  # Make wallpaper accessible to other modules
  home.file.".current-wallpaper".source = defaultWallpaper;
}
