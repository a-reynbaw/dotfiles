{ config, pkgs, ... }:

{
  networking.hostName = "circe";

  users.users.a-reynbaw.home = "/Users/a-reynbaw";

  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/Library/TeX/texbin"
    "/Applications/Wireshark.app/Contents/MacOS"
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.enable = false;
  system.stateVersion = 6;
}
