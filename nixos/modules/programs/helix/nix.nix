{ pkgs, lib, ... }:

{
  programs.helix = {
    ignores = [
      "result"
      "result-*"
    ];

    languages = {
      language = [
        {
          name = "nix";

          language-servers = [
            "nil"
            "nixd"
            "rich-presence-wrapper"
          ];
        }
      ];

      language-server = {
        "nil" = {
          command = "${lib.getExe pkgs.nil}";
        };

        "nixd" = {
          command = "${lib.getExe pkgs.nixd}";
        };
      };
    };
  };

  home.packages = with pkgs; [
    nixpkgs-fmt
    nixpkgs-manual
  ];
}

