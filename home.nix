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

  home.username = "ludat";
  home.homeDirectory = "/home/ludat";
  home.packages = with pkgs-unstable; [
    git
    neovim
    curl
    wl-clipboard
    jetbrains.idea-community
    timewarrior
    taskwarrior-tui
    navi
    yt-dlp
    # This is necessary because some programs require the zed binary and
    # by default it's called zeditor in nixos
    (writeShellScriptBin "zed" "exec -a $0 ${zed-editor}/bin/zeditor $@")
    (writeShellScriptBin "idea" "exec -a $0 ${jetbrains.idea-community}/idea-community/bin/idea $@")

    opencode
    claude-code
    # https://github.com/NixOS/nixpkgs/issues/443704
    # playwright-mcp
    (writeShellScriptBin "mcp-server-playwright" ''
      export PWMCP_PROFILES_DIR_FOR_TEST="$PWD/.pwmcp-profiles"
      exec ${playwright-mcp}/bin/mcp-server-playwright "$@"
    '')
  ];

  systemd.user.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.taskwarrior = {
    enable = true;
    package = pkgs-unstable.taskwarrior3;
  };

  services.playerctld.enable = true;

  programs.zed-editor = {
    enable = true;
    package = pkgs-unstable.zed-editor;
    userSettings = {
      agent = {
        default_profile = "ask";
        always_allow_tool_actions = true;
        default_model = {
          provider = "zed.dev";
          model = "claude-sonnet-4-thinking";
        };
        play_sound_when_agent_done = true;
      };

      base_keymap = "VSCode";
      vim_mode = true;
      ui_font_size = 16;
      buffer_font_size = 16;
      tab_size = 2;

      theme = {
        mode = "system";
        light = "One Light";
        dark = "One Dark";
      };

      file_types = {
        Helm = [
          "**/templates/**/*.tpl"
          "**/templates/**/*.yaml"
          "**/templates/**/*.yml"
          "**/helmfile.d/**/*.yaml"
          "**/helmfile.d/**/*.yml"
        ];
      };

      lsp = {
        hls = {
          initialization_options = {
            haskell = {
              formattingProvider = "stylish-haskell";
            };
          };
        };
      };
    };
  };

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

  programs.btop.enable = true;
  programs.mpv = {
    enable = true;
    bindings = {
      "tab" = "script-binding uosc/toggle-ui";
    };
    scripts = with pkgs.mpvScripts; [
      uosc
      thumbfast
      mpris
      videoclip
      smart-copy-paste-2
    ];
  };
  services.pueue.enable = true;

  programs.kitty = {
    enable = true;
    themeFile = "Argonaut";
    font = {
      name = "Terminess Nerd Font Mono";
      size = 12;
    };
    # shellIntegration.mode = null;
    actionAliases = {
      "launch_tab" = "launch --cwd=current --type=tab";
      "launch_window" = "launch --cwd=current --type=os-window";
    };
    settings = {
      update_check_interval = 0;
      # shell_integration = "enabled";
      scrollback_lines = 100000;
      background_opacity = 0.9;
    };
  };

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
        export PATH=$PATH:${lib.makeBinPath [ pkgs.git ]}
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
