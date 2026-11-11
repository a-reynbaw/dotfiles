{ pkgs, ... }:

{
  # ./package.nix is a derivation, not a module, so it has to be instantiated
  # with callPackage rather than imported. It covers x86_64-linux and
  # aarch64-darwin, which is every system this config is built for.
  home.packages = [ (pkgs.callPackage ./package.nix { }) ];
}
