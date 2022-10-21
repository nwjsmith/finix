{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  nixpkgs.config.allowUnfree = true;

  imports = [ ./hardware-configuration.nix ];

  hardware.parallels.enable = true;
  hardware.video.hidpi.enable = true;
  services.xserver.libinput.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Parallels both only support this being 0 otherwise you see "error switching
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

  environment.systemPackages = [ ];
  virtualization.docker.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = false;
  users.users.root.initialPassword = "root";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
