{ pkgs, lib, ... }:

{
  programs.helix.languages.language-server."rich-presence-wrapper" = {
    command = "${lib.getExe pkgs.rich-presence-wrapper}";
    args = [ "lsp" ];
  };
}

