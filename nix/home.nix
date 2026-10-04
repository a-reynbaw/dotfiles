{ config, pkgs, ... }:

{
  imports = [
    ./modules
  ];

  home.stateVersion = "24.11";
}
