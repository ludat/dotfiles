# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
  stable-pkgs = import inputs.nixpkgs-stable {
    system = pkgs.system;
  };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nix = {
    # since I'm using flakes I don't want channels instead I want nixpkgs to follow
    # my flake's nixpkgs
    channel.enable = false;
    # https://github.com/NixOS/nix/issues/3803#issuecomment-1181667475
    settings = {
      nix-path = [ "nixpkgs=${inputs.nixpkgs}" ];
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    };
  };

  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.useTmpfs = true;
  networking.hostName = "republic-ludat"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  services.unbound = {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" "::1" ];
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

  # Nvidia stuff
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:4:0:0";
    nvidiaBusId = "PCI:1:0:0";
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb = {
      options = "ctrl:nocaps";
      variant = "altgr-intl";
      layout = "us";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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
    shell = pkgs.zsh;
    description = "Lucas David Traverso";
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" "unbound" "libvirtd" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-unstable-2021-11-01"
  ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox-devedition-bin
    chromium
    neovim
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
    tig
    delta
    dyff
    fx
    telegram-desktop
    keepassxc
    dotbot
    stack
    zsh
    fasd
    git-cola
    xsel
    arandr
    slack
    discord
    trippy
    htop
    stack
    postgresql
    pgcli
    zlib.dev
    just
    hyperfine
    ghcid
    docker-compose
    nodejs
    yarn
    kitty
    vscodium
    jetbrains.webstorm
    xh
    bruno
    eza
    watchexec
    dogdns
    ldns
    socat
    nmap
    netcat-openbsd
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
    megasync
    binutils
    unixtools.xxd
    hwatch

    # kubernetes stuff
    k9s
    kubectl
    kubectl-cnpg
    kubectl-klock
    kubectl-explore
    kubernetes-helm
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    stern
    jq
    visidata
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
    emacs29
    (nerdfonts.override {fonts = ["FiraCode" "FiraMono" "Terminus"];})
    ncdu
    nix-diff
    nvd
    nix-tree
    nix-du
    nix-output-monitor
    graphviz
    asusctl

    # kde
    plasma5Packages.kalk
    plasma5Packages.kolourpaint
    kdenlive
    xdotool
    obs-studio

    yaml-language-server
    aria
    (mpv.override { scripts = with mpvScripts; [uosc thumbfast mpris]; })
    spotify
    bcc
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  console.useXkbConfig = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.steam.enable = true;
  programs.zsh.enable = true;
  programs.kdeconnect.enable = true;
  programs.firejail.enable = true;
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  programs.direnv = {
    enable = true;
  };
  programs.virt-manager.enable = true;
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
  };
  services.locate.enable = true;
  #services.flatpak.enable = true;
  #xdg.portal.enable = true;
  #xdg.portal.wlr.enable = true;
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
