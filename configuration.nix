{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  options = {
    host = pkgs.lib.mkOption {
      description = "host of the system";
    };
  };
  config = {
    nix = {
      # since I'm using flakes I don't want channels instead I want nixpkgs to follow
      # my flake's nixpkgs
      channel.enable = false;
      # https://github.com/NixOS/nix/issues/3803#issuecomment-1181667475
      settings = {
        nix-path = [ "nixpkgs=${inputs.nixpkgs}" ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "root"
          "ludat"
        ];
      };
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Bootloader.
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernel.sysctl = {
      "vm.max_map_count" = 1048576;
    };
    boot.loader.systemd-boot = {
      enable = true;
      memtest86.enable = true;
      netbootxyz.enable = true;
    };
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    boot.loader.efi.canTouchEfiVariables = true;
    boot.tmp.useTmpfs = true;
    networking.hostName = config.host;

    # Enable networking
    networking.networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    services.unbound = {
      enable = true;
      resolveLocalQueries = true;
      settings = {
        server = {
          interface = [
            "127.0.0.1"
            "::1"
          ];
          prefetch = true;
          cache-max-negative-ttl = 0;
        };
        forward-zone = [
          {
            name = ".";
            forward-addr = "1.1.1.1@853#cloudflare-dns.com";
            forward-tls-upstream = true;
          }
        ];
      };
    };

    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    # Set your time zone.
    time.timeZone = "America/Argentina/Buenos_Aires";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "es_AR.UTF-8";
      LC_IDENTIFICATION = "es_AR.UTF-8";
      LC_MEASUREMENT = "es_AR.UTF-8";
      LC_MONETARY = "es_AR.UTF-8";
      LC_NAME = "es_AR.UTF-8";
      LC_NUMERIC = "es_AR.UTF-8";
      LC_PAPER = "es_AR.UTF-8";
      LC_TELEPHONE = "es_AR.UTF-8";
      LC_TIME = "es_AR.UTF-8";
    };

    services.displayManager.sddm.enable = true;

    # Configure keymap in X11

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      videoDrivers = [
        "amdgpu"
        "nvidia"
      ];
      xkb = {
        options = "ctrl:nocaps";
        variant = "altgr-intl";
        layout = "us";
      };
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.ludat = {
      isNormalUser = true;
      initialPassword = "ludat"; # mostly for testing with build-vm
      shell = pkgs.zsh;
      description = "Lucas David Traverso";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "wireshark"
        "unbound"
        "libvirtd"
      ];
      packages = with pkgs; [
        #  thunderbird
      ];
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      (
        let
          base = appimageTools.defaultFhsEnvArgs;
        in
        buildFHSEnv (
          base
          // {
            name = "fhs";
            targetPkgs = ps: (base.targetPkgs ps) ++ [ pkg-config ];
            profile = "export FHS=1";
            runScript = "zsh";
            extraOutputsToInstall = [ "dev" ];
          }
        )
      )
      pwgen
      bc
      logseq
      tldr
      parallel
      moreutils
      termdown
      file
      pwvucontrol
      lshw
      pciutils
      usbutils
      inxi
      wget
      openssh
      git
      ffmpeg
      imagemagick
      tig
      delta
      dyff
      fx
      telegram-desktop
      # dotbot
      stack
      zsh
      nushell
      fasd
      fzf
      git-cola

      xsel
      arandr
      slack
      discord
      gping
      htop
      stack
      postgresql
      sqlite
      sqlitestudio
      pgcli
      zlib.dev
      just
      hyperfine
      ghcid
      docker-compose
      lazydocker
      nodejs
      yarn
      vscodium
      xh
      bruno
      eza
      watchexec
      doggo
      openssl
      httptap
      ldns
      socat
      nmap
      netcat-openbsd
      nixos-firewall-tool
      knot-dns
      dig
      shellcheck
      tree
      up
      unp
      unzip
      zip
      hurl
      font-awesome
      xorg.xev
      libnotify
      libreoffice
      binutils
      unixtools.xxd
      unixtools.netstat
      lsof
      hwatch
      updog

      # kubernetes stuff
      k9s
      kubectl
      kubectl-cnpg
      kubectl-klock
      kubectl-explore
      kubelogin-oidc
      kubernetes-helm
      stern
      jq
      visidata
      qsv
      bat
      yq-go
      multitail
      meld
      atuin
      ripgrep
      sd
      fd
      # nixpkgs-stable.legacyPackages.x86_64-linux.emacs
      # emacs
      gmp.dev
      emacs-pgtk
      gnuplot
      ispell
      ncdu
      nix-diff
      dix
      nix-tree
      nix-du
      nix-output-monitor
      graphviz

      # kde
      kdePackages.kalk
      kdePackages.kolourpaint
      kdePackages.kdenlive
      gimp
      wtype
      iw
      wirelesstools
      yaml-language-server
      nil
      aria2
      spotify
      bcc

      # cosmic
      cosmic-ext-applet-weather
      cosmic-ext-applet-minimon
      cosmic-ext-applet-privacy-indicator
      tasks
      examine
      quick-webapps
    ];

    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    console.useXkbConfig = true;

    programs.trippy.enable = true;
    programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
    programs.nh = {
      enable = true;
      flake = "/home/ludat/dotfiles";
    };

    programs.steam = {
      enable = true;
      extest.enable = true;
      gamescopeSession.enable = true;
    };
    programs.zsh.enable = true;
    programs.kdeconnect.enable = true;
    programs.firejail.enable = true;
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    programs.direnv.enable = true;
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # List by default
        zlib
        zstd
        stdenv.cc.cc
        curl
        openssl
        attr
        libssh
        bzip2
        libxml2
        acl
        libsodium
        util-linux
        xz
        systemd

        # My own additions
        xorg.libXcomposite
        xorg.libXtst
        xorg.libXrandr
        xorg.libXext
        xorg.libX11
        xorg.libXfixes
        libGL
        libva
        pipewire
        xorg.libxcb
        xorg.libXdamage
        xorg.libxshmfence
        xorg.libXxf86vm
        libelf

        # Required
        glib
        gtk2

        # Inspired by steam
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/st/steam/package.nix#L36-L85
        networkmanager
        vulkan-loader
        libgbm
        libdrm
        libxcrypt
        coreutils
        pciutils
        zenity
        # glibc_multi.bin # Seems to cause issue in ARM

        # # Without these it silently fails
        xorg.libXinerama
        xorg.libXcursor
        xorg.libXrender
        xorg.libXScrnSaver
        xorg.libXi
        xorg.libSM
        xorg.libICE
        gnome2.GConf
        nspr
        nss
        cups
        libcap
        SDL2
        libusb1
        dbus-glib
        ffmpeg
        # Only libraries are needed from those two
        libudev0-shim

        # needed to run unity
        gtk3
        icu
        libnotify
        gsettings-desktop-schemas
        # https://github.com/NixOS/nixpkgs/issues/72282
        # https://github.com/NixOS/nixpkgs/blob/2e87260fafdd3d18aa1719246fd704b35e55b0f2/pkgs/applications/misc/joplin-desktop/default.nix#L16
        # log in /home/leo/.config/unity3d/Editor.log
        # it will segfault when opening files if you don’t do:
        # export XDG_DATA_DIRS=/nix/store/0nfsywbk0qml4faa7sk3sdfmbd85b7ra-gsettings-desktop-schemas-43.0/share/gsettings-schemas/gsettings-desktop-schemas-43.0:/nix/store/rkscn1raa3x850zq7jp9q3j5ghcf6zi2-gtk+3-3.24.35/share/gsettings-schemas/gtk+3-3.24.35/:$XDG_DATA_DIRS
        # other issue: (Unity:377230): GLib-GIO-CRITICAL **: 21:09:04.706: g_dbus_proxy_call_sync_internal: assertion 'G_IS_DBUS_PROXY (proxy)' failed

        # Verified games requirements
        xorg.libXt
        xorg.libXmu
        libogg
        libvorbis
        SDL
        SDL2_image
        glew110
        libidn
        tbb

        # Other things from runtime
        flac
        freeglut
        libjpeg
        libpng
        libpng12
        libsamplerate
        libmikmod
        libtheora
        libtiff
        pixman
        speex
        SDL_image
        SDL_ttf
        SDL_mixer
        SDL2_ttf
        SDL2_mixer
        libappindicator-gtk2
        libdbusmenu-gtk2
        libindicator-gtk2
        libcaca
        libcanberra
        libgcrypt
        libvpx
        librsvg
        xorg.libXft
        libvdpau
        # ...
        # Some more libraries that I needed to run programs
        pango
        cairo
        atk
        gdk-pixbuf
        fontconfig
        freetype
        dbus
        alsa-lib
        expat
        # for blender
        libxkbcommon

        libxcrypt-legacy # For natron
        libGLU # For natron

        # Appimages need fuse, e.g. https://musescore.org/fr/download/musescore-x86_64.AppImage
        fuse
        e2fsprogs

        # For ghc installed using ghcup
        gmp
        ncurses
      ];
    };
    programs.virt-manager.enable = true;
    programs.obs-studio.enable = true;

    virtualisation.libvirtd.enable = true;
    virtualisation.docker.enable = true;

    # List services that you want to enable:

    services.syncthing = {
      enable = true;
      user = "ludat";
      configDir = "/home/ludat/.config/syncthing";
      dataDir = "/home/ludat/Documents";
      openDefaultPorts = true;
    };
    environment.pathsToLink = [ "/share/zsh" ];

    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.terminess-ttf
      noto-fonts
      hack-font
    ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.11"; # Did you read the comment?

    # specialisation."hyprland".configuration = {
    #   environment.etc."specialisation".text = "hyprland";
    #   services.displayManager.sddm.enable = true;
    #   services.displayManager.sddm.wayland.enable = true;

    #   services.blueman.enable = true;

    #   services.gnome.gnome-keyring.enable = true;
    #   services.upower.enable = true;
    #   fonts.fontDir.enable = true;
    #   services.udisks2.enable = true;
    #   services.locate.enable = true;
    #   programs.hyprland.enable = true;
    #   services.hypridle.enable = true;
    #   programs.hyprland.withUWSM = true;

    #   xdg.portal = {
    #     enable = true;
    #     extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
    #   };

    #   environment.systemPackages = with pkgs; [
    #     wtype
    #   ];
    # };

    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;

    specialisation."plasma".configuration = {
      environment.etc."specialisation".text = "plasma";

      # Undo configurations from cosmic
      services.displayManager.cosmic-greeter.enable = lib.mkForce false;
      services.desktopManager.cosmic.enable = lib.mkForce false;

      services.xserver.enable = true; # optional
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;
      services.desktopManager.plasma6.enable = true;
    };
  };
}
