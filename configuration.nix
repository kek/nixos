# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "potatis"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the GNOME 3 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "ke";

  services.xserver.videoDrivers = [ "amdgpu" ];
  # Configure keymap in X11
  services.xserver.layout = "se";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };
  security.sudo.wheelNeedsPassword = false;

  programs.fish.enable = true;
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  #   firefox
  # ];
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
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "20.09"; # Did you read the comment?

}
