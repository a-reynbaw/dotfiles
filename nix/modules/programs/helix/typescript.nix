{ pkgs, lib, ... }:

{
  programs.helix = {
    languages = {
      language = [
        {
          name = "typescript";

          language-servers = [
            "typescript-language-server"
            "rich-presence-wrapper"
          ];
        }
        {
          name = "javascript";

          language-servers = [
            "typescript-language-server"
            "rich-presence-wrapper"
          ];
        }
      ];

      language-server = {
        "typescript-language-server" = {
          command = "${lib.getExe pkgs.typescript-language-server}";
        };
      };
    };
  };

  home.packages = with pkgs; [];
}
