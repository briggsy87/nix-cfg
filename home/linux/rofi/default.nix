{ config, pkgs, lib, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    extraConfig = {
      modi = "drun,run,filebrowser";
      show-icons = true;
      icon-theme = "Papirus";
      font = "${config.stylix.fonts.monospace.name} 12";
      drun-display-format = "{icon} {name}";
      display-drun = " Apps";
      display-run = " Run";
      display-filebrowser = " Files";
      terminal = "alacritty";
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
      colors = config.lib.stylix.colors;
    in {
      "*" = {
        bg = mkLiteral "#${colors.base00}";
        bg-alt = mkLiteral "#${colors.base01}";
        foreground = mkLiteral "#${colors.base05}";
        selected = mkLiteral "#${colors.base08}";
        active = mkLiteral "#${colors.base0B}";
        text-selected = mkLiteral "#${colors.base00}";
        text-color = mkLiteral "#${colors.base05}";
        border-color = mkLiteral "#${colors.base0C}";
        urgent = mkLiteral "#${colors.base09}";
      };

      "window" = {
        transparency = "real";
        width = mkLiteral "600px";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        border-radius = mkLiteral "8px";
        background-color = mkLiteral "@bg";
      };

      "mainbox" = {
        enabled = true;
        spacing = mkLiteral "15px";
        padding = mkLiteral "20px";
        orientation = mkLiteral "vertical";
        children = map mkLiteral [
          "inputbar"
          "listview"
          "mode-switcher"
        ];
        background-color = mkLiteral "transparent";
      };

      "inputbar" = {
        enabled = true;
        spacing = mkLiteral "10px";
        padding = mkLiteral "12px";
        border-radius = mkLiteral "8px";
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "@foreground";
        children = map mkLiteral [
          "textbox-prompt-colon"
          "entry"
        ];
      };

      "textbox-prompt-colon" = {
        enabled = true;
        expand = false;
        str = "";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "entry" = {
        enabled = true;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "text";
        placeholder = "Search...";
        placeholder-color = mkLiteral "@foreground";
      };

      "mode-switcher" = {
        enabled = true;
        spacing = mkLiteral "10px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground";
        orientation = mkLiteral "horizontal";
      };

      "button" = {
        padding = mkLiteral "10px 16px";
        border-radius = mkLiteral "8px";
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "pointer";
        horizontal-align = mkLiteral "0.5";
      };

      "button selected" = {
        background-color = mkLiteral "@selected";
        text-color = mkLiteral "@text-selected";
      };

      "listview" = {
        enabled = true;
        columns = 1;
        lines = 8;
        cycle = true;
        dynamic = true;
        scrollbar = false;
        layout = mkLiteral "vertical";
        reverse = false;
        fixed-height = true;
        fixed-columns = true;
        spacing = mkLiteral "8px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground";
        cursor = "default";
      };

      "element" = {
        enabled = true;
        spacing = mkLiteral "12px";
        padding = mkLiteral "10px";
        border-radius = mkLiteral "8px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@text-color";
        cursor = mkLiteral "pointer";
      };

      "element normal.normal" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@text-color";
      };

      "element selected.normal" = {
        background-color = mkLiteral "@selected";
        text-color = mkLiteral "@text-selected";
      };

      "element-icon" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        size = mkLiteral "32px";
        cursor = mkLiteral "inherit";
      };

      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };
    };
  };

  # Install icon theme
  home.packages = with pkgs; [
    papirus-icon-theme
  ];
}
