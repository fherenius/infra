{ config, pkgs, lib, modulesPath, ... }: {
  # Import hardware configuration
  imports = [
    ./hardware/vm-aarch64-vmware.nix
    ../modules/vmware-guest.nix
  ];

  # Setup qemu so we can run x86_64 binaries
  boot.binfmt.emulatedSystems = ["x86_64-linux"];

  # Disable the default module and import our override. We have
  # customizations to make this work on aarch64.
  disabledModules = [ "virtualisation/vmware-guest.nix" ];

  # This works through our custom module imported above
  virtualisation.vmware.guest.enable = true;


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
    variables = {
      LIBGL_ALWAYS_SOFTWARE = "1";
      WLR_NO_HARDWARE_CURSORS = "1"; # Required for cursor to work in Wayland
    };
  };

  # Add version of Nix that the host is running
  system.stateVersion = "23.05";

  # Network interface on the M1
  networking = {
    interfaces.enp160.useDHCP = true;
    hostName = "dev-vm";
    useDHCP = true;
  };

  # Qemu
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

  # Setting up xserver
  services.xserver = {
    enable = true;
    dpi = 227;

    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;

      # AARCH64: For now, on Apple Silicon, we must manually set the
      # display resolution. This is a known issue with VMware Fusion.
      sessionCommands = ''
        ${pkgs.xorg.xset}/bin/xset r rate 200 40
        ${pkgs.xorg.xrandr}/bin/xrandr -s '2880x1800'
      '';
    };

    windowManager = {
      i3.enable = true;
    };
  };

  time.timeZone = "Europe/Amsterdam";

  services.openssh = {
    enable = true;
    settings = {
      # Add my own SSH key as accepted public key here
      PermitRootLogin = "no";
      PasswordAuthentication = true;    
    };
  };

  users = {
    # Don't allow the creation of extra users at runtime
    mutableUsers = false;
  };
}