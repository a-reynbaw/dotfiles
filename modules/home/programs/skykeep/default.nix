{ pkgs, ... }:

{
  # ./package.nix is a derivation, not a module, so it has to be instantiated
  # with callPackage rather than imported.
  home.packages = [ (pkgs.callPackage ./package.nix { }) ];
}
