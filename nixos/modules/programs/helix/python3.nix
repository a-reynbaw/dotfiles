{ pkgs, lib, ... }:


let
  python3 = pkgs.python3.withPackages (
    p: with p; [
      ty
      ruff

      virtualenv
      pwntools
    ]
  );
in

{
  programs.helix = {
    ignores = [
      ".python/"
    ];

    languages = {
      language = [
        {
          name = "python";

          language-servers = [
            "ty"
            "ruff"
            "rich-presence-wrapper"
          ];
        }
      ];

      language-server = {
        "ty" = {
          command = "${lib.getExe' python3 "ty"}";
          args = [ "server" ];
        };

        "ruff" = {
          command = "${lib.getExe' python3 "ruff"}";
          args = [ "server" ];
        };
      };
    };
  };

  home.packages = [
    python3
  ];
}

