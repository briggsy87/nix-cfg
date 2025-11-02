{ config, pkgs, lib, ... }:

{
  # Hyprland and essential tools
  home.packages = with pkgs; [
    # Wayland utilities
    swww              # Wallpaper daemon
    grim              # Screenshot tool
    slurp             # Screen area selector
    wl-clipboard      # Clipboard utilities
    swappy            # Screenshot editor
    cliphist          # Clipboard history
    hyprpolkitagent   # Polkit agent for Hyprland

    # Notifications
    libnotify         # Send notifications (notify-send command)

    # System utilities
    pavucontrol       # Audio control
    brightnessctl     # Brightness control
    playerctl         # Media player control
    networkmanagerapplet  # Network manager tray

    # File manager
    xfce.thunar       # GUI file manager
    xfce.thunar-volman
    xfce.thunar-archive-plugin
  ];

  # Enable Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = [ "--all" ];
    };
    xwayland.enable = true;

    settings = {
      # Startup applications
      exec-once = [
        # Clipboard management
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"

        # Environment variables
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

        # System services
        "systemctl --user start hyprpolkitagent"

        # Wallpaper daemon
        "killall -q swww-daemon; sleep .5 && swww-daemon"

        # Network manager applet
        "nm-applet --indicator"

        # Bluetooth manager applet
        "blueman-applet"

        # Set wallpaper (uses Stylix wallpaper)
        "sleep 1.5 && swww img $HOME/.current-wallpaper"
      ];

      # Input configuration
      input = {
        kb_layout = "us";
        numlock_by_default = true;
        repeat_delay = 300;
        follow_mouse = 1;
        float_switch_override_focus = 0;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.8;
        };
      };

      # General settings with Material Design aesthetics
      general = {
        "$modifier" = "SUPER";
        layout = "dwindle";
        gaps_in = 5;
        gaps_out = 7;
        border_size = 3;
        resize_on_border = true;
        # Gradient border using Stylix colors
        "col.active_border" = "rgb(${config.lib.stylix.colors.base08}) rgb(${config.lib.stylix.colors.base0C}) 45deg";
        "col.inactive_border" = "rgb(${config.lib.stylix.colors.base01})";
      };

      # Dwindle layout settings
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      # Material Design 3 decorations with transparency
      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          ignore_opacity = false;
          new_optimizations = true;
          xray = false;
        };
        shadow = {
          enabled = true;
          range = 8;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        # Opacity settings for inactive windows
        inactive_opacity = 0.92;
        active_opacity = 1.0;
      };

      # Material Design 3 animations (END-4 style)
      animations = {
        enabled = true;
        bezier = [
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
        ];
        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "windowsIn, 1, 3, md3_decel, popin 60%"
          "windowsOut, 1, 3, md3_accel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 3, md3_decel"
          "layersIn, 1, 3, menu_decel, slide"
          "layersOut, 1, 1.6, menu_accel"
          "fadeLayersIn, 1, 2, menu_decel"
          "fadeLayersOut, 1, 4.5, menu_accel"
          "workspaces, 1, 7, menu_decel, slidefadevert 20%"
          "specialWorkspace, 1, 7, menu_decel, slidefadevert 20%"
        ];
      };

      # Miscellaneous settings
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
        vfr = true;  # Variable frame rate
        vrr = 2;     # Variable refresh rate (try 0 if issues with NVIDIA)
      };

      # Cursor settings
      cursor = {
        sync_gsettings_theme = true;
        no_hardware_cursors = true;
        warp_on_change_workspace = true;
      };

      # Xwayland settings
      xwayland = {
        force_zero_scaling = true;
      };

      # Keybindings
      bind = [
        # Applications
        "$modifier, RETURN, exec, alacritty"
        "$modifier, T, exec, ghostty"
        "$modifier SHIFT, RETURN, exec, kitty"
        "$modifier, B, exec, firefox"
        "$modifier, F, exec, thunar"
        "$modifier, SPACE, exec, rofi -show drun"

        # Window management
        "$modifier, Q, killactive"
        "$modifier, W, togglefloating"
        "$modifier SHIFT, F, fullscreen, 0"
        "$modifier, P, pseudo"
        "$modifier SHIFT, I, togglesplit"

        # Focus movement (arrow keys)
        "$modifier, left, movefocus, l"
        "$modifier, right, movefocus, r"
        "$modifier, up, movefocus, u"
        "$modifier, down, movefocus, d"

        # Focus movement (vim keys)
        "$modifier, h, movefocus, l"
        "$modifier, l, movefocus, r"
        "$modifier, k, movefocus, u"
        "$modifier, j, movefocus, d"

        # Move windows
        "$modifier SHIFT, h, movewindow, l"
        "$modifier SHIFT, l, movewindow, r"
        "$modifier SHIFT, k, movewindow, u"
        "$modifier SHIFT, j, movewindow, d"

        # Workspaces
        "$modifier, 1, workspace, 1"
        "$modifier, 2, workspace, 2"
        "$modifier, 3, workspace, 3"
        "$modifier, 4, workspace, 4"
        "$modifier, 5, workspace, 5"
        "$modifier, 6, workspace, 6"
        "$modifier, 7, workspace, 7"
        "$modifier, 8, workspace, 8"
        "$modifier, 9, workspace, 9"
        "$modifier, 0, workspace, 10"

        # Move to workspace
        "$modifier SHIFT, 1, movetoworkspace, 1"
        "$modifier SHIFT, 2, movetoworkspace, 2"
        "$modifier SHIFT, 3, movetoworkspace, 3"
        "$modifier SHIFT, 4, movetoworkspace, 4"
        "$modifier SHIFT, 5, movetoworkspace, 5"
        "$modifier SHIFT, 6, movetoworkspace, 6"
        "$modifier SHIFT, 7, movetoworkspace, 7"
        "$modifier SHIFT, 8, movetoworkspace, 8"
        "$modifier SHIFT, 9, movetoworkspace, 9"
        "$modifier SHIFT, 0, movetoworkspace, 10"

        # Screenshots
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "$modifier SHIFT, S, exec, grim -g \"$(slurp)\" - | swappy -f -"

        # System
        "$modifier, L, exec, hyprlock"
        "$modifier SHIFT, E, exit"
        "$modifier SHIFT, R, exec, hyprctl reload && notify-send 'Hyprland' 'Configuration reloaded' --icon=dialog-information"
      ];

      # Mouse bindings
      bindm = [
        "$modifier, mouse:272, movewindow"
        "$modifier, mouse:273, resizewindow"
      ];

      # Media keys
      bindl = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };

    # Extra configuration
    extraConfig = ''
      # Monitor configuration - adjust scale to 1.25 or 1.5 if things are too large
      # Format: monitor=name,resolution,position,scale
      # Use 1.0 for normal, 1.25 for slightly smaller, 1.5 for much smaller
      monitor=,preferred,auto,1.0

      # Enable blur on waybar and rofi for that glass effect
      layerrule = blur, waybar
      layerrule = blur, rofi
    '';
  };

  # Symlink wallpapers to Pictures directory
  home.file."Pictures/Wallpapers" = {
    source = ../../theme/wallpapers;
    recursive = true;
  };
}
