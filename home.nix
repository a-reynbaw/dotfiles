{ pkgs, lib, ... }:

{
  imports = [
    ./modules/home/programs/default.nix
  ];

  home.stateVersion = "24.11";
}
