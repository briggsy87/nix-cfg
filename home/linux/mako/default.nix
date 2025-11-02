{ config, pkgs, lib, ... }:

{
  # Mako - Lightweight notification daemon for Wayland
  services.mako = {
    enable = true;

    # Appearance
    backgroundColor = "#${config.lib.stylix.colors.base00}dd";
    textColor = "#${config.lib.stylix.colors.base05}";
    borderColor = "#${config.lib.stylix.colors.base0C}";
    progressColor = "over #${config.lib.stylix.colors.base08}";

    borderSize = 2;
    borderRadius = 8;

    # Font
    font = "${config.stylix.fonts.sansSerif.name} 11";

    # Layout
    width = 350;
    height = 100;
    margin = "10";
    padding = "12";

    # Position (top-right corner)
    anchor = "top-right";

    # Behavior
    defaultTimeout = 5000;  # 5 seconds
    ignoreTimeout = false;

    # Grouping
    maxVisible = 3;
    sort = "-time";

    # Icons
    icons = true;
    maxIconSize = 48;
    iconPath = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
  };
}
