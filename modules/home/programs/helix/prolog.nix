{ pkgs, lib, ... }:

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
          command = "${lib.getExe pkgs.swi-prolog}";
        };
      };
    };
  };
  home.packages = with pkgs; [];
}
