{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      background-opacity = 0.8;
      background-blur = true;

      cursor-style = "block_hollow";
      
      font-family = "Adwaita Mono";

      fullscreen = true;
      
      mouse-hide-while-typing = true;
      
      theme = "rose-pine-default";
    };
  };

  home.pkgs = with pkgs; [
    adwaita-fonts
  ];
}
