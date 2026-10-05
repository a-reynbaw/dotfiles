{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    rpw.url = "git+https://git.31c0.org/threadexio/rich-presence-wrapper";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    rpw,
    home-manager,
    darwin,
    ...
  }@inputs: {
    nixosConfigurations.hecate = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [
         {
           nixpkgs.overlays = [ rpw.overlays.default ];
         }
         ./hosts/hecate/configuration.nix
         ./hosts/hecate/hardware-configuration.nix
          home-manager.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.sia = ./modules/nixos/home.nix;
            };
          }
       ];
    };

    darwinConfigurations.circe = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        {
          nixpkgs.overlays = [ rpw.overlays.default ];
        }
        ./hosts/circe/configuration.nix
        home-manager.darwinModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.a-reynbaw = ./modules/nix-darwin/home.nix;
          };
        }
      ];
    };
  };
}
