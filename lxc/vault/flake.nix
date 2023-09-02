{
  description = "";
  inputs.deploy-rs.url = "github:serokell/deploy-rs";

  outputs = { self, nixpkgs, deploy-rs }: {
    nixosConfiguration.vault = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };

    deploy.nodes.vault = {
      hostname = "192.168.1.210";
      fastConnection = true;
      profiles = {
        system = {
          sshUser = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfiguration.vault;
          user = "root";
          magicRollback = false;
          remoteBuild = true;
        };
      };
    };
  };
}