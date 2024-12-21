# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable ZFS during boot
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportAll = false;
  boot.zfs.forceImportRoot = false;
  # ZFS expects a host ID to link the pool to the machine
  networking.hostId = "cad537bd";

  networking.hostName = "saturn";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  users.users.jryans = {
    isNormalUser = true;
    # Enable sudo and network management
    extraGroups = [ "wheel" "networkmanager" ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  programs.firefox.enable = true;

  # First version of NixOS installed on this machine
  # Used to maintain compatibility with data created in older versions
  system.stateVersion = "24.11"; # Did you read the comment?
}

