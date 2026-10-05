{ config, pkgs, ... }:

{
  networking.hostName = "circe";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = 6;
}
