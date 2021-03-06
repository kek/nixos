# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  my = import
    (builtins.fetchTarball https://github.com/kek/nixpkgs/tarball/b78bc9a9008)
    { config = config.nixpkgs.config; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # boot.initrd.availableKernelModules = [
  #       "intel_idle"
  #       "intel_pstate"
  #     ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  # boot.resumeDevice = "/dev/nvme0n1p8";

  # boot.kernelPackages = my.linuxPackages-rt_latest;
  boot.kernelPackages = my.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.extraModulePackages = with config.boot.kernelPackages; [ "vmd" ];

  # boot.kernelParams = [ "mem_sleep_default=deep" "intel_idle.max_cstate=0" ];
  # boot.kernelParams = [ "intel_idle.max_cstate=0" ];
  environment.variables."MOZ_USE_XINPUT2" = "1";

  # boot.kernelParams = [ /* list of command line arguments */ ];

  # boot.extraModulePackages = with config.boot.kernelPackages; [ vmd ];
  # boot.extraModulePackages = with config.boot.kernelPackages; [ intel_idle ];
  boot.blacklistedKernelModules = [ "psmouse" ];
  boot.kernelPatches = [ {
    name = "vmd-config";
    patch = null;
    extraConfig = ''
      VMD y
    '';
  } ];
  #       PREEMPT y   #testa!

  networking.hostName = "dill"; # Define your hostname.

  hardware.cpu.intel.updateMicrocode = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  # networking.interfaces.enp0s13f0u1.useDHCP = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.layout = "se";
  # services.xserver.xkbOptions = "eurosign:e";

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.desktopManager.pantheon.enable = true;
  # services.pantheon.contractor.enable = true;
  # xdg.portal.enable = true;

  # services.xserver = {
  #   desktopManager = { pantheon.enable = true; default = "elementary"; };
  #   displayManager.lightdm.enable = true;
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # services.xserver.libinput = {
  #   enable = true;
  #   touchpad.disableWhileTyping = true;
  # };

  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ke = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.fish.promptInit = ''
    any-nix-shell fish --info-right | source
  '';

  programs.gnupg.agent.enable = true;
  programs.steam.enable = true;

  virtualisation.docker.enable = true;
  users.extraGroups.libvirtd.members = [ "ke" ];
  boot.kernelModules = [ "kvm-intel" ];
  virtualisation.libvirtd.enable = true;

  # services.keybase.enable = true;
  # services.kbfs.enable = true;

  services.acpid.enable = true;
  services.acpid.logEvents = true;
  #services.acpid.lidEventCommands = "dbus-send --type=method_call --dest=org.gnome.ScreenSaver /org/gnome/ScreenSaver org.gnome.ScreenSaver.Lock";
  #services.acpid.lidEventCommands = "date >>/tmp/lid-event";
  # services.acpid.lidEventCommands = "/run/current-system/sw/bin/pm-suspend-hybrid";
  # services.acpid.lidEventCommands = ''
  #   [ "$1" = "button/lid LID close" ] && /run/current-system/sw/bin/pm-hibernate
  # '';
  services.logind.lidSwitch = "hibernate";
  # services.acpid.lidEventCommands = "/run/current-system/sw/bin/pm-suspend";

  services.fprintd.enable = true;

  services.flatpak.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_MIN_FREQ_ON_BAT=500000;
      CPU_BOOST_ON_BAT = false;
    };
  };

  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_BAT="powersave";
  #     CPU_SCALING_GOVERNOR_ON_AC="powersave";

  #     # 100 being the maximum, limit the speed of my CPU to reduce
  #     # heat and increase battery usage:
  #     CPU_MAX_PERF_ON_AC=75;
  #     CPU_MAX_PERF_ON_BAT=40;

  #     CPU_SCALING_MAX_FREQ_ON_BAT=2500000;
  #     CPU_BOOST_ON_BAT = false;
  #     CPU_ENERGY_PERF_POLICY_ON_AC="power";
  #     CPU_ENERGY_PERF_POLICY_ON_BAT="power";


  #   };
  # };

  powerManagement.cpufreq.min = 400000;

  security.pam.services.login.fprintAuth = true;
  security.pam.services.xscreensaver.fprintAuth = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim git my.firefox emacs bat ctags desktop-file-utils direnv dmenu espeak et
    fd file fzf gcc gimp gitAndTools.diff-so-fancy gitAndTools.gh
    gitAndTools.tig gnumake gnupg gparted hack-font hddtemp htop httpie i3
    i3status inotify-tools kakoune killall libnotify lm_sensors lsof mc
    mercurial ncdu niv nix-tree nmap nodePackages.node2nix pass silver-searcher
    telnet unzip virt-manager wget xdg-desktop-portal xdg-desktop-portal-gtk
    xdotool xorg.xdpyinfo xorg.xkill xsel keybase keybase-gui any-nix-shell
    prettyping my.vscode pinentry
    discord
    slack
    pipewire
    prettyping
    elixir_1_11
    erlangR23
    google-chrome
    go
    visidata
    acpi
    jq
    glxinfo
    i7z
    pmutils
    tmux
    qemu_kvm
    my.jetbrains.idea-community
    heroku
    postgresql
    redis
  ];

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      hack-font
    ];
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
