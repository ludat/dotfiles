{
  config,
  pkgs,
  lib,
  pkgs-unstable,
  ...
}:

let
  configDir = "/home/ludat/dotfiles";
  mkConfigLink =
    path:
    config.lib.file.mkOutOfStoreSymlink (
      toString (configDir + lib.removePrefix (toString ./.) (toString path))
    );
in
{
  imports = [
  ];

  home.packages = with pkgs; [
    playerctl
    hyprshot
    hyprpicker
    libgtop
    brightnessctl
    pavucontrol
    qalculate-gtk
    navi
  ];

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  services.blueman-applet.enable = true;

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  programs.hyprlock.enable = true;
  services.hyprshell.enable = true;
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
  # services.hyprpaper.enable = true; # also crashes
  services.hyprpolkitagent.enable = true;
  services.udiskie.enable = true;
  services.cliphist.enable = true;

  programs.hyprpanel = {
    enable = true;
    # dontAssertNotificationDaemons = true;
  };

  services.dunst = {
    enable = false;
    settings = {
      global = {
        monitor = "eDP-1";
        # width = 300;
        # height = 300;
        # offset = "30x50";
        origin = "top-right";
        # transparency = 10;
        frame_color = "#eceff1";
        # font = "Droid Sans 9";
      };

      urgency_normal = {
        background = "#37474f";
        foreground = "#eceff1";
        timeout = 10;
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland/hyprland.conf;
    plugins = [
      pkgs.hyprlandPlugins.hy3
      pkgs.hyprlandPlugins.hyprsplit
      # this add a weird outline to I'm disabling it for now
      # pkgs.hyprlandPlugins.hyprspace
    ];
    systemd.enable = false;
  };

  # wayland.windowManager.hyprland.settings = {
  #   "$mod" = "SUPER";
  #   bind =
  #     [
  #       "$mod, F, exec, firefox"
  #       ", Print, exec, grimblast copy area"
  #     ]
  #     ++ (
  #       # workspaces
  #       # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
  #       builtins.concatLists (builtins.genList (i:
  #           let ws = i + 1;
  #           in [
  #             "$mod, code:1${toString i}, workspace, ${toString ws}"
  #             "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
  #           ]
  #         )
  #         9)
  #     );
  # };

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
