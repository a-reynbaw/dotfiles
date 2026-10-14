{ pkgs, lib, ... }:

{
  programs.helix = {
    languages = {
      language = [
        {
          name = "latex";

          language-servers = [
            "texlab"
            "rich-presence-wrapper"
          ];
        }
      ];

      language-server = {
        "texlab" = {
          command = "${lib.getExe pkgs.texlab}";
        };
      };
      
    };
  };

  home.packages = with pkgs; [
    texlab
  ];
}
