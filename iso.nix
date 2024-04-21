# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./tetrd-custom.nix
  ];

  # Enable tetrd
  services.tetrd-custom.enable = true;

  # Fingerprint support
  services.fprintd = {
    enable = true;
    package = pkgs.fprintd-tod;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-vfs0090;
    };
  };


  # Bootloader.
  boot.loader.systemd-boot = { 
    enable = true;
    configurationLimit = 2;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kuala_Lumpur";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ms_MY.UTF-8";
    LC_IDENTIFICATION = "ms_MY.UTF-8";
    LC_MEASUREMENT = "ms_MY.UTF-8";
    LC_MONETARY = "ms_MY.UTF-8";
    LC_NAME = "ms_MY.UTF-8";
    LC_NUMERIC = "ms_MY.UTF-8";
    LC_PAPER = "ms_MY.UTF-8";
    LC_TELEPHONE = "ms_MY.UTF-8";
    LC_TIME = "ms_MY.UTF-8";
  };

  # For Intel IGPU
  services.xserver.videoDrivers = [ "modesetting" ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.wayland = false;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    snapshot
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    yelp
    gnome-weather
    gnome-maps
    gnome-contacts
    cheese # webcam tool
    gnome-music
    gnome-terminal
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);


  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
    xkb.options = "ctrl:nocaps";
  };

  console.useXkbConfig = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Remove mouse acceleration
  services.xserver.libinput.mouse.accelProfile = "flat";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lenix = {
    isNormalUser = true;
    description = "lenix";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      vscode
      obsidian
      git
      nixos-generators
    ];
  };


  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "lenix";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        imap jk <Esc>
        imap kj <Esc>
        vmap jk <Esc>
        vmap kj <Esc>
        cmap jk <Esc>
        cmap kj <Esc>
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set clipboard+=unnamed
      '';
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    xclip
  ];

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}