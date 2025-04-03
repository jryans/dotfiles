# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "flakes" "nix-command" ];

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

  # Scrub ZFS pool monthly
  services.zfs.autoScrub.enable = true;

  # Networking
  networking.hostName = "saturn";
  networking.networkmanager.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
    };
  };

  # Localisation
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.fwupd.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  users.users.jryans = {
    isNormalUser = true;
    # Enable sudo and network management
    extraGroups = [ "wheel" "networkmanager" ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      liberation_ttf
    ];
    # Map PostScript fonts to Liberation instead of TeX Gyre
    fontconfig = {
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <match>
            <test name="family"><string>Helvetica</string></test>
            <edit name="family" mode="assign" binding="strong">
              <string>Liberation Sans</string>
            </edit>
          </match>
          <match>
            <test name="family"><string>Times</string></test>
            <edit name="family" mode="assign" binding="strong">
              <string>Liberation Serif</string>
            </edit>
          </match>
          <match>
            <test name="family"><string>Courier</string></test>
            <edit name="family" mode="assign" binding="strong">
              <string>Liberation Mono</string>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "enpass"
    "vscode"
  ];

  environment.systemPackages = with pkgs; [
    bc # Used in shell init scripts (move to user config?)
    enpass
    file
    fzf # Used in shell init scripts (move to user config?)
    git
    gnome-extension-manager
    gnome-tweaks
    htop
    libinput
    jetbrains-mono
    meld
    patchelf
    vim
    vscode
    zotero
  ];

  programs.firefox.enable = true;

  # First version of NixOS installed on this machine
  # Used to maintain compatibility with data created in older versions
  system.stateVersion = "24.11";
}

