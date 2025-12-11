{ config, pkgs, lib, ... }:

{
  # Hyprlock - Screen locker for Hyprland
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 0;
        no_fade_in = false;
      };

      background = [
        {
          monitor = "";
          path = "~/.current-wallpaper";
          blur_passes = 3;
          blur_size = 7;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      # Time
      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<span>$(date +'%H:%M')</span>\"";
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_size = 120;
          font_family = "${config.stylix.fonts.monospace.name}";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        # Date
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<span>$(date +'%A, %B %d')</span>\"";
          color = "rgb(${config.lib.stylix.colors.base05})";
          font_size = 24;
          font_family = "${config.stylix.fonts.sansSerif.name}";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
      ];

      # Password input
      input-field = [
        {
          monitor = "";
          size = "300, 50";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.35;
          dots_center = true;
          outer_color = "rgb(${config.lib.stylix.colors.base0C})";
          inner_color = "rgb(${config.lib.stylix.colors.base00})";
          font_color = "rgb(${config.lib.stylix.colors.base05})";
          fade_on_empty = false;
          placeholder_text = "<span foreground='##${config.lib.stylix.colors.base04}'>Enter Password...</span>";
          hide_input = false;
          position = "0, -200";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # Hypridle - Idle daemon for auto-lock
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300; # 5 minutes
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 600; # 10 minutes
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900; # 15 minutes
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800; # 30 minutes
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
