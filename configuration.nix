{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };
  nixpkgs.config.allowUnfree = true;

  hardware.parallels.enable = true;
  hardware.video.hidpi.enable = true;
  services.xserver.libinput.enable = true;

  boot.initrd.availableKernelModules = [
    "virtio_net"
    "virtio_pci"
    "virtio_mmio"
    "virtio_blk"
    "virtio_scsi"
    "9p"
    "9pnet_virtio"
  ];
  boot.initrd.kernelModules =
    [ "virtio_balloon" "virtio_console" "virtio_rng" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Parallels only supports this being 0 otherwise you see "error switching
  # console mode" on boot
  boot.loader.systemd-boot.consoleMode = "0";

  networking = {
    hostName = "dev";
    networkmanager.enable = true;
    firewall.enable = false;
    interfaces.enp0s5.useDHCP = true;
    useDHCP = false;
  };

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  environment.systemPackages = with pkgs; [ vim ];
  environment.variables = { EDITOR = "vim"; };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = false;
  users.users.root.initialPassword = "root";
  users.users.nwjsmith = {
    isNormalUser = true;
    home = "/home/nwjsmith";
    extraGroups = [ "docker" "wheel" ];
    hashedPassword =
      "$6$PUhJVThTRYeN3KJP$Bz6iTc4rbVAQmFGCX9ou15JXqG8IlEpVTjyEMRPhn3ALJ6uIPzgCj7.RY3L1fC3ZZwM97UTUYzER/vSiAzUm6.";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtWR1nXAvSmsd92TC9rMuZIh1Ec8cqxYr3BIyUxdNyy"
    ];
  };

  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 192;

    autoRepeatDelay = 200;
    autoRepeatInterval = 40;

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "scale";
    };

    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
    };

    windowManager.i3.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
