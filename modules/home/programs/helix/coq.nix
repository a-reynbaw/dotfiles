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

          # One Rocq checker at a time: coq-lsp and vsrocq both elaborate the
          # whole file, so listing both doubles the kernel work and reports
          # every error twice. Swap "coq-lsp" for "vsrocq" to try the other.
          language-servers = [
            "coq-lsp"
            "rich-presence-wrapper"
          ];
        }
      ];

      language-server = {
        # coq-lsp sits under rocqPackages, not at top level, and sets no
        # meta.mainProgram, so the binary has to be named explicitly.
        "coq-lsp" = {
          command = "${lib.getExe' pkgs.rocqPackages.coq-lsp "coq-lsp"}";
        };

        # The server half of the VsRocq VS Code extension. It is a plain LSP
        # server, so helix can drive it, but the proof view, stepping and
        # queries all ride on vsrocq's own protocol extensions, which helix
        # does not speak: here it is worth diagnostics, hover, completion,
        # goto-definition, document symbols and folding, and no goals.
        "vsrocq" = {
          command = "${lib.getExe' pkgs.rocqPackages.vsrocq-language-server "vsrocqtop"}";

          # vsrocqtop parses this whole record at once, both from
          # initializationOptions and from the didChangeConfiguration helix
          # sends after it, and silently drops it if a required field is
          # missing - hence every field below, even the ones left at the
          # extension's own default.
          #
          # mode = 1 is Continuous; the default 0 is Manual, which checks
          # nothing until the client asks it to step, so under helix it would
          # sit there reporting no errors at all.
          config = {
            proof = {
              delegation = "None";
              workers = 1;
              mode = 1;
              block = true;
              pointInterpretationMode = 0;
            };

            goals = {
              messages.full = true;
              ppmode = "Pp";
            };

            completion = {
              enable = false;
              algorithm = 1;
              unificationLimit = 100;
            };

            diagnostics = {
              enable = true;
              full = false;
            };

            # In gigabytes.
            memory.limit = 4;

            interrupt.preempt = false;
          };
        };
      };
    };
  };

  home.packages = with pkgs; [
    rocq-core
    rocqPackages.coq-lsp

    # Puts vsrocqtop on PATH, which is all the VS Code extension needs: with
    # vsrocq.path left empty it looks the binary up there itself.
    rocqPackages.vsrocq-language-server
  ];
}
