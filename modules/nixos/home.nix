{ pkgs, lib, ... }:

{
  imports = [
    ../../home.nix
    ../home/programs/keyboard/defaut.nix
  ];
}