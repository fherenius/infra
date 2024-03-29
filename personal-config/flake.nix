{
  description = "NixOS setup for my personal machines";

  inputs = {
    # Main nixpkgs repository, with pinned version.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    # Unstable nixpkgs for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      # Pin this to the same version as the main nixpgks repo
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, deploy-rs, home-manager, ... }: {
    nixosConfigurations.dev-vm = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./machines/vm-aarch64-vmware.nix
        ./users/fester/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.fester = import ./users/fester/home.nix;
        }
      ];
    };

    deploy.nodes.dev-vm = {
      hostname = "192.168.64.2";
      fastConnection = true;
      profiles = {
        system = {
          sshUser = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.dev-vm;
          user = "root";
          autoRollback = false;
          magicRollback = false;
          remoteBuild = true;
        };
      };
    };
  };
}