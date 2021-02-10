{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "potatis";

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

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "ke" ];
  users.extraGroups.docker.members = [ "ke" ];
  users.extraGroups.libvirtd.members = [ "ke" ];
  boot.kernelModules = [ "kvm-amd" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

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

 fileSystems."/C" =
   {
     device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_500GB_S4EVNJ0N311518N-part2";
     fsType = "ntfs";
   };

 fileSystems."/D" =
   {
     device = "/dev/disk/by-id/ata-WDC_WD20EZAZ-00GGJB0_WD-WX21AC9HAYY0-part2";
     fsType = "ntfs";
   };

 fileSystems."/G" =
   {
     device = "/dev/disk/by-id/ata-Samsung_SSD_870_QVO_1TB_S5SVNG0N723350T-part1";
     fsType = "ntfs";
   };

 environment.systemPackages = with pkgs; [
    discord
    emacs
    firefox
    fish
    git
    gitAndTools.gh
    gnupg
    google-chrome
    hack-font
    keybase
    keybase-gui
    kbfs
    killall
    pass
    pinentry
    slack
    teams
    vim
    vscode
    xsel
    nix-tree
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    pipewire
    google-chrome
    wayvnc
    gcc
    qemu_kvm
    virt-manager
    gnumake
    htop
    nmap
    direnv
    bat
    xorg.xkill
    silver-searcher
    gitAndTools.diff-so-fancy
    any-nix-shell
    file
    steam-run
    unzip
    jetbrains.idea-community
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "20.09";
}
