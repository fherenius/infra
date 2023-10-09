{ config, pkgs, modulesPath, ... }: {
  # Network interface on the M1
  networking.interfaces.enp0s10.useDHCP = true;

  # Qemu
  services.spice-vdagentd.enable = true;

  # Need this for hardware acceleration to work
  environment.variables.LIBGL_ALWAYS_SOFTWARE = "1";

  # Some pkgs claim to not support aarch64 while they work
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
}