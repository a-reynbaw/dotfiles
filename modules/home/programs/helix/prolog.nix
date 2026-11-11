{ pkgs, lib, ... }:

let
  # The Prolog LSP ships as a SWI pack, not as part of swipl itself.
  lsp-server-pack = pkgs.fetchzip {
    name = "swipl-pack-lsp_server";
    url = "https://github.com/jamesnvc/lsp_server/archive/refs/tags/v3.18.1.tar.gz";
    sha256 = "0zvryghg5227np9knk70dc2in61q4fpmvimlia2w71jgd0kb91z6";
  };

  swi-prolog-lsp = pkgs.swi-prolog.override {
    extraPacks = [ "'file://${lsp-server-pack}'" ];
  };
in

{
  programs.helix = {
    languages = {
      language = [
        {
          name = "prolog";

          language-servers = [
            "swipl"
            "rich-presence-wrapper"
          ];
        }
      ];

      language-server = {
        "swipl" = {
          command = "${lib.getExe swi-prolog-lsp}";

          # Bare swipl is an interactive REPL; these flags make it speak LSP.
          args = [
            "-g"
            "use_module(library(lsp_server))."
            "-g"
            "lsp_server:main"
            "-t"
            "halt."
            "--"
            "stdio"
          ];
        };
      };
    };
  };
  home.packages = with pkgs; [];
}
