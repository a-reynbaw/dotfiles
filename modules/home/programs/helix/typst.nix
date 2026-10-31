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

  # Allow home-manager to install and index per-user fonts (needed below).
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    tinymist

    # Fonts needed by the modern-cv typst template (cv.typst).
    source-sans
    source-sans-pro
    font-awesome
  ];
}

