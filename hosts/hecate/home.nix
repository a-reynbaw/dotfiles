# home-manager config for sia on hecate: the shared NixOS home layer plus the
# programs wanted on this host alone. Anything that should follow the user to
# every machine belongs in ../../home.nix, and anything NixOS-wide (but not
# host-specific) in ../../modules/nixos/home.nix.
{ ... }:

{
  imports = [
    ../../modules/nixos/home.nix
    ../../modules/home/programs/skykeep
  ];
}
