{ config, pkgs, lib, ... }:

{
  # Mako - Lightweight notification daemon for Wayland
  # Uses Stylix colors dynamically, but with transparency added
  services.mako = {
    enable = true;

    settings = {
      # Appearance - colors pulled from Stylix (updates when wallpaper changes!)
      # The 'dd' suffix adds transparency (87% opacity)
      background-color = "#${config.lib.stylix.colors.base00}dd";
      text-color = "#${config.lib.stylix.colors.base05}";
      border-color = "#${config.lib.stylix.colors.base0C}";
      progress-color = "over #${config.lib.stylix.colors.base08}";

      border-size = 2;
      border-radius = 8;

      # Font from Stylix
      font = "${config.stylix.fonts.sansSerif.name} 11";

      # Layout
      width = 350;
      height = 100;
      margin = "10";
      padding = "12";

      # Position (top-right corner)
      anchor = "top-right";

      # Behavior
      default-timeout = 5000;  # 5 seconds
      ignore-timeout = false;

      # Grouping
      max-visible = 3;
      sort = "-time";

      # Icons
      icons = true;
      max-icon-size = 48;
      icon-path = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
    };
  };
}
