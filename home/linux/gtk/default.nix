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

  # Qt configuration
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };

  # Additional theming packages
  home.packages = with pkgs; [
    # GTK themes
    adwaita-icon-theme
    papirus-icon-theme

    # Cursor theme (from Stylix)
    bibata-cursors

    # QT integration
    libsForQt5.qt5ct
    qt6Packages.qt6ct
  ];

  # Home cursor theme
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
