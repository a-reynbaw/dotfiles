{ pkgs, lib, ... }:

{
  programs.helix = {
    languages = {
      language = [
        {
          name = "bash";

          language-servers = [
            "bash-language-server"
            "rich-presence-wrapper"
          ];
        }
      ];

      language-server = {
        "bash-language-server" = {
          command = "${lib.getExe pkgs.bash-language-server}";
          args = [ "start" ];
        };
      };
    };
  };

  home.packages = with pkgs; [
    shfmt
    shellcheck
  ];
}

