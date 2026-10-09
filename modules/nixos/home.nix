{ pkgs, lib, ... }:

{
  imports = [
    ../../home.nix
    ../home/programs/plasma/default.nix
  ];
}