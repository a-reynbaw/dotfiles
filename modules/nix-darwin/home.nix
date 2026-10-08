{ pkgs, lib, ... }:

{
  imports = [
    ../../home.nix
    ../home/services/colima
    ../home/programs/sketchybar
  ];
}
