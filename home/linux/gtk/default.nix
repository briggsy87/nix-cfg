{ config, pkgs, lib, ... }:

{
  # GTK configuration
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Qt configuration - let Stylix handle theming
  # Stylix will automatically configure Qt to match your color scheme

  # Additional theming packages
  home.packages = with pkgs; [
    # GTK themes
    adwaita-icon-theme
    papirus-icon-theme

    # QT integration
    libsForQt5.qt5ct
    qt6Packages.qt6ct
  ];

  # Cursor theme is configured by Stylix in home/theme/default.nix
}
