{ pkgs, lib, ... }:

{
  programs.helix = {
    ignores = [
      ".cache/"
      ".build/"
      "build/"
    ];

    languages = {
      language = [
        {
          name = "c";

          language-servers = [
            "clangd"
            "rich-presence-wrapper"
          ];
        }
        {
          name = "cpp";

          language-servers = [
            "clangd"
            "rich-presence-wrapper"
          ];
        }
      ];

      language-server = {
        "clangd" = {
          command = "${lib.getExe' pkgs.clang-tools "clangd"}";
        };
      };
    };
  };

  home.packages = with pkgs; [
    gcc
    clang-tools
    man-pages
    man-pages-posix
    gdb
    gef
    strace
    ltrace
    valgrind
  ];
}

