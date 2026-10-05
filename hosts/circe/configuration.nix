{ config, pkgs, ... }:

{
  networking.hostName = "circe";

  users.users.a-reynbaw.home = "/Users/a-reynbaw";

  # nix-darwin's /etc/zprofile doesn't run path_helper, so /etc/paths.d isn't read.
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
