{
  description = "";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
  };
  
  outputs = { self, nixpkgs, deploy-rs, ... }: {
    nixosConfiguration.k3s-agent-0 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./configuration.nix
      ];
    };

    deploy.nodes.k3s-agent-0 = {
      hostname = "192.168.1.221";
      fastConnection = true;
      profiles = {
        system = {
          sshUser = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfiguration.k3s-agent-0;
          user = "root";
          autoRollback = false;
          magicRollback = false;
          remoteBuild = true;
        };
      };
    };
  };
}