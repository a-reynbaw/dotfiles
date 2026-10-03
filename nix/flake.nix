{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rpw.url = "git+https://git.31c0.org/threadexio/rich-presence-wrapper";
  };

  outputs = {self, nixpkgs, rpw, home-manager, ... }@inputs: {
    nixosConfigurations.hecate = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [
           {
             nixpkgs.overlays = [ rpw.overlays.default ];
           }
         ./configuration.nix
         ./hardware-configuration.nix
          home-manager.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.sia = ./home.nix;
            };
          }
       ];
    };
  };
}
