{ config, pkgs, lib, inputs, ... }:

let
  configDir = "/home/ludat/dotfiles";
  mkConfigLink = path: config.lib.file.mkOutOfStoreSymlink
    (toString (configDir + lib.removePrefix (toString ./.) (toString path)));
in
{
  imports = [
  ];

  home.username = "ludat";
  home.homeDirectory = "/home/ludat";
  home.packages = with pkgs; [
    git
    neovim
    curl
  ];

  systemd.user.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.playerctld.enable = true;

  services.megasync = {
    enable = true;
    forceWayland = true;
  };

  programs.keepassxc = {
    enable = true;
    settings = {
      General = {
        ConfigVersion = 2;
      };

      GUI = {
        CompactMode = true;
        MinimizeOnClose = true;
        MinimizeToTray = true;
        ShowTrayIcon = true;
        TrayIconAppearance = "monochrome-dark";
      };
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [
      rofi-calc
      rofi-systemd
    ];
    modes = [
      "drun"
      "window"
      "calc"
      "recursivebrowser"
      "run"
      "combi"
    ];
  };
  programs.hyprlock.enable = true;
  # services.hypridle.enable = true;
  # services.hyprpaper.enable = true;
  services.hyprpolkitagent.enable = true;
  wayland.windowManager.hyprland.systemd.enableXdgAutostart = true;

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
          font-size: 13px;
      }

      window#waybar {
          background-color: rgba(43, 48, 59, 0.5);
          border-bottom: 3px solid rgba(100, 114, 125, 0.5);
          color: #ffffff;
          transition-property: background-color;
          transition-duration: .5s;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      /*
      window#waybar.empty {
          background-color: transparent;
      }
      window#waybar.solo {
          background-color: #FFFFFF;
      }
      */

      window#waybar.termite {
          background-color: #3F3F3F;
      }

      window#waybar.chromium {
          background-color: #000000;
          border: none;
      }

      button {
          /* Use box-shadow instead of border so the text isn't offset */
          box-shadow: inset 0 -3px transparent;
          /* Avoid rounded borders under each button name */
          border: none;
          border-radius: 0;
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      button:hover {
          background: inherit;
          box-shadow: inset 0 -3px #ffffff;
      }

      /* you can set a style on hover for any module like this */
      #pulseaudio:hover {
          background-color: #a37800;
      }

      #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #ffffff;
      }

      #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
      }

      #workspaces button.active {
          background-color: #64727D;
          box-shadow: inset 0 -3px #ffffff;
      }

      #workspaces button.urgent {
          background-color: #eb4d4b;
      }

      #mode {
          background-color: #64727D;
          box-shadow: inset 0 -3px #ffffff;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #power-profiles-daemon,
      #mpd {
          padding: 0 10px;
          color: #ffffff;
      }

      #window,
      #workspaces {
          margin: 0 4px;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }

      #clock {
          background-color: #64727D;
      }

      #battery {
          background-color: #ffffff;
          color: #000000;
      }

      #battery.charging, #battery.plugged {
          color: #ffffff;
          background-color: #26A65B;
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: #000000;
          }
      }

      /* Using steps() instead of linear as a timing function to limit cpu usage */
      #battery.critical:not(.charging) {
          background-color: #f53c3c;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: steps(12);
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #power-profiles-daemon {
          padding-right: 15px;
      }

      #power-profiles-daemon.performance {
          background-color: #f53c3c;
          color: #ffffff;
      }

      #power-profiles-daemon.balanced {
          background-color: #2980b9;
          color: #ffffff;
      }

      #power-profiles-daemon.power-saver {
          background-color: #2ecc71;
          color: #000000;
      }

      label:focus {
          background-color: #000000;
      }

      #cpu {
          background-color: #2ecc71;
          color: #000000;
      }

      #memory {
          background-color: #9b59b6;
      }

      #disk {
          background-color: #964B00;
      }

      #backlight {
          background-color: #90b1b1;
      }

      #network {
          background-color: #2980b9;
      }

      #network.disconnected {
          background-color: #f53c3c;
      }

      #pulseaudio {
          background-color: #f1c40f;
          color: #000000;
      }

      #pulseaudio.muted {
          background-color: #90b1b1;
          color: #2a5c45;
      }

      #wireplumber {
          background-color: #fff0f5;
          color: #000000;
      }

      #wireplumber.muted {
          background-color: #f53c3c;
      }

      #custom-media {
          background-color: #66cc99;
          color: #2a5c45;
          min-width: 100px;
      }

      #custom-media.custom-spotify {
          background-color: #66cc99;
      }

      #custom-media.custom-vlc {
          background-color: #ffa000;
      }

      #temperature {
          background-color: #f0932b;
      }

      #temperature.critical {
          background-color: #eb4d4b;
      }

      #tray {
          background-color: #2980b9;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
      }

      #idle_inhibitor {
          background-color: #2d3436;
      }

      #idle_inhibitor.activated {
          background-color: #ecf0f1;
          color: #2d3436;
      }

      #mpd {
          background-color: #66cc99;
          color: #2a5c45;
      }

      #mpd.disconnected {
          background-color: #f53c3c;
      }

      #mpd.stopped {
          background-color: #90b1b1;
      }

      #mpd.paused {
          background-color: #51a37a;
      }

      #language {
          background: #00b093;
          color: #740864;
          padding: 0 5px;
          margin: 0 5px;
          min-width: 16px;
      }

      #keyboard-state {
          background: #97e1ad;
          color: #000000;
          padding: 0 0px;
          margin: 0 5px;
          min-width: 16px;
      }

      #keyboard-state > label {
          padding: 0 5px;
      }

      #keyboard-state > label.locked {
          background: rgba(0, 0, 0, 0.2);
      }

      #scratchpad {
          background: rgba(0, 0, 0, 0.2);
      }

      #scratchpad.empty {
      	background-color: transparent;
      }

      #privacy {
          padding: 0;
      }

      #privacy-item {
          padding: 0 5px;
          color: white;
      }

      #privacy-item.screenshare {
          background-color: #cf5700;
      }

      #privacy-item.audio-in {
          background-color: #1ca000;
      }

      #privacy-item.audio-out {
          background-color: #0069d4;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        # height = 30;
        # output = [
        #   "eDP-1"
        #   "HDMI-A-1"
        # ];
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ ];
        modules-right = [
          "tray"
          "battery"
          "pulseaudio"
          # "pulseaudio#microphone"
          # "backlight"
          "cpu"
          "memory"
          "disk"
          "temperature"
          # "custom/updates"
          "network"
          "clock"
          # "custom/lock_screen"
          # "custom/power
        ];
        "hyprland/window" = {
          "separate-outputs" = true;
        };

        clock = {
          format = "{:%F - %H:%M:%S} ";
          format-alt = "{:%A, %B %d, %Y (%R)}  ";
          interval = 1;
          timezone = "America/Argentina/Buenos_Aires";
        };
      };
    };
  };

  services.network-manager-applet.enable = true;
  services.dunst = {
    enable = true;
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
  # services.mako = {
  #   enable = true;
  #   settings = {
  #     actions = true;
  #     anchor = "top-right";
  #     background-color = "#000000";
  #     border-color = "#FFFFFF";
  #     border-radius = 0;
  #     font = "monospace 10";
  #     height = 100;
  #     width = 300;
  #     icons = true;
  #     ignore-timeout = false;
  #     layer = "top";
  #     margin = 10;
  #     markup = true;
  #
  #     "actionable=true" = {
  #       anchor = "top-left";
  #     };
  #   };
  # };

  # programs.kitty.enable = true;
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = builtins.readFile ./hyprland/hyprland.conf;
  wayland.windowManager.hyprland.systemd.enable = false;

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

  home.file = {
    ".zshrc" = {
      source = mkConfigLink zsh/zshrc;
      onChange = ''
        set -euo pipefail
        ZINIT_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
        if [ ! -d $ZINIT_HOME ]; then mkdir -p "$(dirname $ZINIT_HOME)"; fi
        if [ ! -d $ZINIT_HOME/.git ]; then ${pkgs.git}/bin/git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"; fi
      '';
    };

    ".config/nvim" = {
      source = mkConfigLink ./nvim;
      onChange = ''
        export PATH=$PATH:${lib.makeBinPath [pkgs.git]}
        cd .config/nvim
        if [ ! -f autoload/plug.vim ]; then
          ${pkgs.curl}/bin/curl -fLo autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;
          ${pkgs.neovim}/bin/nvim --headless +'PlugInstall --sync' +qall;
        fi
      '';
    };

    ".doom.d" = {
      source = mkConfigLink ./doom;
      onChange = ''
        if [ ! -d ~/.config/emacs ]; then ${pkgs.git}/bin/git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs; fi
      '';
    };

    ".tmux.conf".source = mkConfigLink ./tmux/tmux.conf;
    ".tmux" = {
      source = mkConfigLink ./tmux/tmux;
      onChange = ''
        if [ ! -d ~/.tmux/plugins/tpm ]; then ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm; fi
      '';
    };
    ".local/bin".source = mkConfigLink ./bin;
    ".stack/hooks".source = mkConfigLink stack/hooks;
    ".stack/global-project".source = mkConfigLink stack/global-project;
    ".bundle/config".source = mkConfigLink bundler/config;
  };
  xdg.configFile = {
    "ranger".source = mkConfigLink ./ranger;
    "git".source = mkConfigLink ./git;
    "i3".source = mkConfigLink ./i3;
    "ripgreprc".source = mkConfigLink ./ripgreprc;
    "yazi".source = mkConfigLink ./yazi;
    "k9s".source = mkConfigLink ./k9s;
    "atuin".source = mkConfigLink ./atuin;
    "direnv".source = mkConfigLink ./direnv;
    "kitty".source = mkConfigLink ./kitty;
    # "hypr/hyperland.conf".source = mkConfigLink ./hypr/hyperland.conf;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
