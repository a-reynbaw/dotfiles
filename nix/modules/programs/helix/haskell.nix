{ pkgs, lib, ... }:

{
  programs.helix = {
    languages = {
      language = [
        {
          name = "haskell";

          language-servers = [
            "haskell-language-server"
            "rich-presence-wrapper"
          ];
        }
      ];

      language-server = {
        "haskell-language-server" = {
          command = "${lib.getExe pkgs.haskell-language-server}";
        };
      };
    };
  };

  home.packages = with pkgs; [
    ghc
  ];
}
