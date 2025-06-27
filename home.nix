{ config, pkgs, inputs, ... }:

let
  configDir = "/home/ludat/dotfiles";
  mkConfigLink = path: config.lib.file.mkOutOfStoreSymlink
    (toString (configDir + pkgs.lib.removePrefix (toString ./.) (toString path)));
in
{
  imports = [
    # ./plasma.nix
  ];
  home.username = "ludat";
  home.homeDirectory = "/home/ludat";
  home.packages = with pkgs; [
    git
    neovim
    curl
  ];

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

  programs.wofi.enable = true;
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  services.hyprpaper.enable = true;
  services.hyprpolkitagent.enable = true;

  programs.waybar = {
    enable = true;
    systemd.enable = true;
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
          "pulseaudio#microphone"
          "backlight"
          "cpu"
          "memory"
          "disk"
          "temperature"
          # "custom/updates"
          "network"
          "hyprland/language"
          # "custom/lock_screen"
          # "custom/power
        ];
      };
    };
  };

  services.network-manager-applet.enable = true;
  services.mako.enable = true;

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
        export PATH=$PATH:${pkgs.lib.makeBinPath [pkgs.git]}
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
