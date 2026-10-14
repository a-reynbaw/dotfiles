{ pkgs, lib, ... }:

{
  # unfree: needs nixpkgs.config.allowUnfree on the host
  programs.claude-code = {
    enable = true;
  };
}
