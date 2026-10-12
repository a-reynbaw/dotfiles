{ pkgs, lib, ... }:

{
  imports = [
    ./bash.nix
    ./c.nix
    ./haskell.nix
    ./latex.nix
    ./markdown.nix
    ./nix.nix
    ./prolog.nix
    ./python3.nix
    ./rich-presence-wrapper.nix
    ./rust.nix
    ./typescript.nix
    ./typst.nix
  ];

  programs.helix = {
    enable = true;

    ignores = [
      "!.gitignore"
    ];

    settings = {
      theme = "mellow";

      editor = {
        line-number = "relative";
        auto-format = true;
        preview-completion-insert = false;
        rulers = [80];
        color-modes = true;
        insert-final-newline = false;
        popup-border = "all";

        statusline = {
          left = [
            "mode"
            "spinner"
            "file-name"
            "file-modification-indicator"
            "read-only-indicator"
          ];

          center = [ "version-control" ];

          right = [
            "total-line-numbers"
            "file-type"
            "diagnostics"
            "position"
          ];
          
          separator = "|";
        };

        cursor-shape = {
          insert = "bar";
          select = "underline";
        };

        whitespace = {
          render = {
            space = "all";
            tab = "all";
          };

          characters = {
            space = "·";
            tab = "→";
            tabpad = ".";
          };
        };
      };
    };

    themes = lib.listToAttrs (
      map
        (path: {
          name = lib.removeSuffix ".toml" (lib.baseNameOf path);
          value = lib.importTOML path;
        })
        [
          ./themes/sonokai_default.toml
          ./themes/mellow_transparent.toml
        ]
    );
  };

  home.packages = with pkgs; [];
}
