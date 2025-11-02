{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = [{
      layer = "top";
      position = "top";
      height = 40;
      spacing = 8;

      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "battery"
        "tray"
      ];

      # Workspaces
      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
        sort-by-number = true;
      };

      # Window title
      "hyprland/window" = {
        max-length = 50;
        separate-outputs = true;
      };

      # Clock
      "clock" = {
        interval = 60;
        format = "  {:%H:%M}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = "  {:%Y-%m-%d}";
      };

      # Audio
      "pulseaudio" = {
        format = "{icon}  {volume}%";
        format-bluetooth = "{icon}  {volume}%";
        format-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol";
      };

      # Network
      "network" = {
        format-wifi = "  {essid}";
        format-ethernet = "  Wired";
        format-disconnected = "󰤮  Disconnected";
        tooltip-format = "{ifname}: {ipaddr}";
        on-click = "nm-connection-editor";
      };

      # CPU
      "cpu" = {
        interval = 5;
        format = "  {usage}%";
        tooltip = true;
      };

      # Memory
      "memory" = {
        interval = 5;
        format = "  {percentage}%";
        tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G";
      };

      # Battery
      "battery" = {
        interval = 60;
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon}  {capacity}%";
        format-icons = [ "" "" "" "" "" ];
        format-charging = "  {capacity}%";
        format-plugged = "  {capacity}%";
        tooltip-format = "{timeTo}";
      };

      # System tray
      "tray" = {
        spacing = 10;
      };
    }];

    # Styling with Stylix colors
    style = let
      colors = config.lib.stylix.colors;
    in ''
      * {
        font-family: ${config.stylix.fonts.monospace.name}, monospace;
        font-size: 13px;
        font-weight: bold;
        min-height: 0;
      }

      window#waybar {
        background: alpha(#${colors.base00}, 0.9);
        color: #${colors.base05};
        border-radius: 0;
      }

      #workspaces {
        margin: 0 8px;
      }

      #workspaces button {
        padding: 0 8px;
        color: #${colors.base04};
        background: transparent;
        border: none;
        border-radius: 8px;
        margin: 4px 2px;
      }

      #workspaces button.active {
        background: linear-gradient(45deg, #${colors.base08}, #${colors.base0C});
        color: #${colors.base00};
      }

      #workspaces button.urgent {
        background: #${colors.base08};
        color: #${colors.base00};
      }

      #workspaces button:hover {
        background: alpha(#${colors.base04}, 0.2);
      }

      #window {
        margin: 0 8px;
        color: #${colors.base05};
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 12px;
        margin: 4px 4px;
        background: alpha(#${colors.base01}, 0.6);
        border-radius: 8px;
        color: #${colors.base05};
      }

      #battery.charging {
        background: alpha(#${colors.base0B}, 0.3);
      }

      #battery.warning {
        background: alpha(#${colors.base0A}, 0.3);
      }

      #battery.critical {
        background: alpha(#${colors.base08}, 0.3);
      }

      #pulseaudio.muted {
        color: #${colors.base03};
      }

      #network.disconnected {
        color: #${colors.base08};
      }
    '';
  };
}
