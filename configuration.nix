# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "republic-ludat"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkbOptions = "ctrl:nocaps";
  services.xserver.videoDrivers = [ "nvidia" ];

  # Nvidia stuff
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
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

  # Enable the XFCE Desktop Environment.
  services.xserver.desktopManager.xfce = {
    enable = true;
    # noDesktop = true;
    enableXfwm = false;
  };
  services.xserver.windowManager.i3.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ludat = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Lucas David Traverso";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox-devedition-bin
    chromium
    neovim
    moreutils
    parallel
    tmux
    ranger
    lshw
    pciutils
    wget
    xorg.xkill
    xfce.xfce4-whiskermenu-plugin
    xfce.xfce4-pulseaudio-plugin
    tmux
    openssh
    git
    tig
    delta
    dyff
    fx
    telegram-desktop
    keepassxc
    dotbot
    stack
    zsh
    direnv
    fasd
    nerdfonts
    git-cola
    xsel
    arandr
    slack
    trippy
    htop
    stack
    postgresql
    zlib.dev
    just
    ghcid
    docker-compose
    nodejs
    yarn
    kitty
    vscode
    jetbrains.webstorm
    xh
    dogdns
    unp
    hurl
    font-awesome
    xorg.xev
    libnotify

    # kubernetes stuff
    k9s
    kubectl
    kubectl-cnpg
    kubectl-klock
    kubectl-explore
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    stern
    jq
    yq-go
    heroku
    multitail
    bitwarden
    meld
    atuin
    ripgrep
    fd
    emacs29
    ncdu
    fira-code-nerdfont
    terminus-nerdfont

    # kde
    plasma5Packages.kalk
    xdotool

    aria
    mpv
    spotify
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
  #services.flatpak.enable = true;
  #xdg.portal.enable = true;
  #xdg.portal.wlr.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
