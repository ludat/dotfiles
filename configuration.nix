# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
  stable-pkgs = import inputs.nixpkgs-stable {
    config.allowUnfree = true;
    system = pkgs.system;
  };
in {
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
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "ludat" ];
    };
  };

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
  networking.networkmanager.enable = true;
  services.unbound = {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" "::1" ];
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
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" "nvidia" ];
    xkb = {
      options = "ctrl:nocaps";
      variant = "altgr-intl";
      layout = "us";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ludat = {
    isNormalUser = true;
    initialPassword = "ludat"; # mostly for testing with build-vm
    shell = pkgs.zsh;
    description = "Lucas David Traverso";
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" "unbound" "libvirtd" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox-devedition
    chromium
    neovim
    pwgen
    bc
    logseq
    tldr
    parallel
    moreutils
    termdown
    file
    tmux
    ranger
    yazi
    # for previews for yazi
      poppler
      ffmpegthumbnailer
    #
    simplescreenrecorder
    xdragon
    helvum
    lshw
    pciutils
    usbutils
    inxi
    wget
    xorg.xkill
    tmux
    openssh
    git
    ffmpeg
    imagemagick
    tig
    pueue
    delta
    dyff
    fx
    telegram-desktop
    # dotbot
    stack
    zsh
    nushell
    fasd
    git-cola

    xsel
    wl-clipboard
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
    jetbrains.webstorm
    jetbrains.idea-ultimate
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
    hurl
    font-awesome
    xorg.xev
    libnotify
    libreoffice
    binutils
    unixtools.xxd
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
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    stern
    jq
    visidata
    qsv
    bat
    yq-go
    heroku
    multitail
    bitwarden
    meld
    atuin
    ripgrep
    sd
    fd
    # nixpkgs-stable.legacyPackages.x86_64-linux.emacs
    # emacs
    emacs30-pgtk
    gnuplot
    ispell
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.terminess-ttf
    ncdu
    nix-diff
    nvd
    nix-tree
    nix-du
    nix-output-monitor
    graphviz

    # kde
    kdePackages.kalk
    kdePackages.kolourpaint
    kdePackages.kdenlive
    wtype

    yaml-language-server
    aria
    (mpv.override
      { scripts = with mpvScripts; [
        uosc
        thumbfast
        mpris
        videoclip
        smart-copy-paste-2
      ]; })
    yt-dlp
    spotify
    bcc
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

  programs.steam.enable = true;
  programs.zsh.enable = true;
  programs.kdeconnect.enable = true;
  programs.firejail.enable = true;
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  programs.direnv.enable = true;
  programs.nix-ld.enable = true;
  programs.virt-manager.enable = true;
  programs.obs-studio.enable = true;

  programs.hyprland.enable = true;
  programs.hyprland.withUWSM  = true;

  virtualisation.libvirtd.enable = true;
  # virtualisation.libvirtd.qemu.ovmf.packages = [ pkgs.OVMFFull.fd pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd ];
  virtualisation.docker.enable = true;
  #fonts.fontDir.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.syncthing = {
    enable = true;
    user = "ludat";
    configDir = "/home/ludat/.config/syncthing";
    dataDir = "/home/ludat/Documents";
    openDefaultPorts = true;
  };
  services.udisks2.enable = true;
  services.locate.enable = true;
  # for hyprland
  services.gnome.gnome-keyring.enable = true;
  #services.flatpak.enable = true;
  #xdg.portal.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  };
}
