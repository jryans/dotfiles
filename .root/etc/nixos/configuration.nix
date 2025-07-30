# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  pkgsLocal,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # First version of NixOS installed on this machine
  # Used to maintain compatibility with data created in older versions
  system.stateVersion = "24.11";

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable ZFS during boot
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportAll = false;
  boot.zfs.forceImportRoot = false;

  # Localisation
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Networking
  networking = {
    hostName = "saturn";
    # ZFS expects a host ID to link the pool to the machine
    hostId = "cad537bd";
    networkmanager = {
      enable = true;
      dns = "none";
    };
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
    ];
    hosts = {
      "10.0.0.14" = [ "umn.local" ];
    };
    firewall = {
      # Disable reverse path filter, interferes with VPN
      checkReversePath = false;
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
    };
  };

  services.fwupd.enable = true;

  services.gnome.core-developer-tools.enable = true;

  services.printing.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "gb,us";
    };
  };

  # Scrub ZFS pool monthly
  services.zfs.autoScrub.enable = true;

  users.users.jryans = {
    isNormalUser = true;
    # Enable sudo and network management
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      liberation_ttf
      source-code-pro
      source-sans
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

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "bcompare"
      "enpass"
      "steam"
      "steam-unwrapped"
      "unrar"
      "vscode"
    ];

  environment.systemPackages = with pkgs; [
    bc # Used in shell init scripts (move to user config?)
    bcompare
    ccache
    dmidecode
    enpass
    file
    fzf # Used in shell init scripts (move to user config?)
    ghostscript
    git
    git-absorb
    git-revise
    gnome-extension-manager
    gnome-shell-extensions
    gnome-tweaks
    htop
    hub
    hyperfine
    libgtop # Used by GNOME shell extensions (system monitor, session manager)
    libinput
    jetbrains-mono
    man-pages
    meld
    mesa-demos
    nix-tree
    nixfmt-rfc-style
    patchelf
    config.boot.kernelPackages.perf
    pipe-rename
    poppler_utils
    protonvpn-gui
    psmisc
    pkgsLocal.rclone
    ptyxis
    qpdf
    restic
    sd
    stress
    tree
    unrar
    vim
    vscode
    wirelesstools
    zeal
    zotero
  ];

  environment.variables = {
    GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = false;
  };

  programs.firefox.enable = true;

  programs.fw-fanctrl.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
