{
  description = "";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    home-manager.url = "github:nix-community/home-manager";
  };
  
  outputs = { self, nixpkgs, deploy-rs, home-manager, ... }: {
    nixosConfiguration.vault = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.vault = import ./home/home.nix;
        }
      ];
    };

    deploy.nodes.vault = {
      hostname = "192.168.1.210";
      fastConnection = true;
      profiles = {
        system = {
          sshUser = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfiguration.vault;
          user = "root";
          autoRollback = false;
          magicRollback = false;
          remoteBuild = true;
        };
      };
    };
  };
}