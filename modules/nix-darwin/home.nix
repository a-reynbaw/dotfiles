{ pkgs, lib, ... }:

{
  imports = [
    ../../home.nix
    ../home/services/colima
  ];
}
