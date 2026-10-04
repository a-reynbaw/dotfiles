{ pkgs, lib, ... }:

{
  programs.helix = {
    languages = {
      language = [
        {
          name = "markdown";
          rulers = [ 90 ];

          language-servers = [
            "marksman"
            "rich-presence-wrapper"
          ];
        }
      ];

      language-server = {
        "marksman" = {
          command = "${lib.getExe pkgs.marksman}";
          args = [ "server" ];
        };
      };
    };
  };
}

