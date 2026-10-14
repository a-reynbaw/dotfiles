{ pkgs, lib, ... }:

{
  programs.helix = {
    languages = {
      language = [
        {
          name = "typst";

          language-servers = [
            "tinymist"
            "rich-presence-wrapper"
          ];
        }
      ];

      language-server = {
        "tinymist" = {
          command = "${lib.getExe pkgs.tinymist}";
        };
      };
    };
  };

  home.packages = with pkgs; [
    tinymist
  ];
}

