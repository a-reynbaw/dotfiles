{ config, pkgs, ... }:

{
  networking.hostName = "circe";

  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  users.users.a-reynbaw.home = "/Users/a-reynbaw";
  system.primaryUser = "a-reynbaw";

  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/Library/TeX/texbin"
    "/Applications/Wireshark.app/Contents/MacOS"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.enable = false;
  system.stateVersion = 6;
}
