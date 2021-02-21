{ config, pkgs, ... }:

let
  my = import
    (builtins.fetchTarball https://github.com/kek/nixpkgs/tarball/master)
    { config = config.nixpkgs.config; };
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = my.linuxPackages_latest;

  networking.hostName = "potatis";
  networking.extraHosts =
    ''
      127.0.0.1 kafka01 zookeeper01
    '';

  time.timeZone = "Europe/Stockholm";

  networking.interfaces.enp5s0.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "ke";

  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.layout = "se";

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.driSupport32Bit = true;

  virtualisation.docker.enable = true;
  # virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "ke" ];
  users.extraGroups.docker.members = [ "ke" ];
  users.extraGroups.libvirtd.members = [ "ke" ];
  boot.kernelModules = [ "kvm-amd" ];
  virtualisation.libvirtd.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  users.users.lm = {
    isNormalUser = true;
  };
  users.users.ke = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };
  security.sudo.wheelNeedsPassword = false;

  programs.fish.enable = true;
  programs.fish.promptInit = ''
    any-nix-shell fish --info-right | source
  '';

  services.keybase.enable = true;
  services.kbfs.enable = true;

  programs.steam.enable = true;

  fileSystems."/windows" =
    {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_500GB_S4EVNJ0N311518N-part2";
      fsType = "ntfs";
    };

  fileSystems."/data" =
    {
      device = "/dev/disk/by-id/ata-WDC_WD20EZAZ-00GGJB0_WD-WX21AC9HAYY0-part2";
      fsType = "ntfs";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-id/ata-Samsung_SSD_870_QVO_1TB_S5SVNG0N723350T-part1";
      fsType = "ext4";
    };

  environment.systemPackages = with pkgs; [
    any-nix-shell
    bat
    cifs-utils
    desktop-file-utils
    direnv
    discord
    dmenu
    emacs
    espeak
    et
    fd
    file
    file
    firefox
    fish
    fzf
    gcc
    gimp
    git
    gitAndTools.diff-so-fancy
    gitAndTools.gh
    gitAndTools.tig
    gnumake
    gnupg
    google-chrome
    google-chrome
    gparted
    hack-font
    hddtemp
    heroku
    htop
    httpie
    i3
    i3status
    inotify-tools
    jetbrains.idea-community
    kbfs
    keybase
    keybase-gui
    killall
    libnotify
    lm_sensors
    lutris
    lsof
    mc
    mercurial
    ncdu
    niv
    nix-tree
    nmap
    nodePackages.node2nix
    pass
    pciutils
    pinentry
    pipewire
    qemu_kvm
    racket
    samba
    silver-searcher
    slack
    spotify
    steam-run
    teams
    telnet
    tintin
    tinyfugue
    unzip
    vim
    virt-manager
    wget
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdotool
    xdotool
    xorg.xdpyinfo
    xorg.xkill
    xsel
    my.vscode
  ];

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      hack-font
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "20.09";
}
