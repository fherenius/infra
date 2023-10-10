{ config, pkgs, lib, modulesPath, ... }: {
  # Import hardware configuration
  imports = [
    ./hardware/vm-aarch64-utm.nix
  ];

  # Careful updating this
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix = {
    # Use unstable to be able to use Flakes
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment = {
    # Packages to always install
    systemPackages = with pkgs; [
      git # Used by Flake
    ];

    # Need this for hardware acceleration to work
    variables.LIBGL_ALWAYS_SOFTWARE = "1";
  };

  # Add version of Nix that the host is running
  system.stateVersion = "23.05";

  # Network interface on the M1
  networking = {
    interfaces.enp0s10.useDHCP = true;
    hostName = "dev-vm";
    useDHCP = false;
  };

  # Qemu
  services.spice-vdagentd.enable = true;
  hardware.opengl.enable = true;

  # Systemd EFI bootloader
  boot.loader = {
    systemd-boot = {
      enable = true;
      # Required by VMWare and others. Not sure for UTM, just putting it there.
      consoleMode = "0";
    };
    efi.canTouchEfiVariables = true;
  };

  nixpkgs.config = {
    # Some pkgs claim to not support aarch64 while they work
    allowUnfree = true;
    allowUnsupportedSystem = true;
  };

  security = {
    # We're in a dev vm, who needs a password for sudo?
    sudo.wheelNeedsPassword = false;

    # Polkit to allow running Sway from Home-Manager
    polkit.enable = true;
  };

  # Virtualisation settings
  virtualisation.docker.enable = true;

  # Internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  # Don't think we need sound in our VM
  # but now I don't get to use PipeWire
  sound.enable = false;

  time.timeZone = "Europe/Amsterdam";

  services.openssh = {
    enable = true;
    PermitRootLogin = "no";
    PasswordAuthentication = false;    
  };

  users = {
    # Don't allow the creation of extra users at runtime
    mutableUsers = false;
  };
}