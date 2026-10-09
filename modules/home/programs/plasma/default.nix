{ ... }:

{
  imports = [
    ./keyboard.nix
    ./kwin.nix
    ./panels.nix
    ./shortcuts.nix
    ./windows.nix
    ./workspace.nix
  ];

  programs.plasma.enable = true;
}
