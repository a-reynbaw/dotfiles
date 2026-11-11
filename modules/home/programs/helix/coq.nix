{ pkgs, lib, ... }:

{
  programs.helix = {
    languages = {
      # Unlike the other languages here, helix 25.07 ships no coq entry at
      # all, so this has to define the whole language rather than just attach
      # a server to a built-in one. No tree-sitter grammar is bundled either:
      # the LSP works, but highlighting and indent queries stay off.
      language = [
        {
          name = "coq";
          scope = "source.coq";

          # Rocq still uses .v, which helix already hands to V and to
          # verilog. A user entry is merged last and so wins the extension.
          file-types = [ "v" ];

          # Coq has no line comment, only (* ... *), so there is no
          # comment-token to set here.
          block-comment-tokens = {
            start = "(*";
            end = "*)";
          };

          # coq-lsp resolves Require paths out of _CoqProject, so the root
          # has to be the project, not the directory of the open file.
          roots = [
            "_CoqProject"
            "dune-project"
          ];

          indent = {
            tab-width = 2;
            unit = "  ";
          };

          language-servers = [
            "coq-lsp"
            "rich-presence-wrapper"
          ];
        }
      ];

      language-server = {
        # coq-lsp sits under coqPackages, not at top level, and sets no
        # meta.mainProgram, so the binary has to be named explicitly.
        "coq-lsp" = {
          command = "${lib.getExe' pkgs.coqPackages.coq-lsp "coq-lsp"}";
        };
      };
    };
  };

  home.packages = with pkgs; [
    rocq-core
    coqPackages.coq-lsp
  ];
}
