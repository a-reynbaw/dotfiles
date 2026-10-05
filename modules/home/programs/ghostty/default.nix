{ pkgs, lib, ... }:

let
  # Ghostty theme files use `key = value` lines (not TOML), with "palette"
  # repeated once per color index, so parse them as such instead.
  parseGhosttyTheme =
    path:
    let
      lines = lib.splitString "\n" (builtins.readFile path);
      parsed = builtins.filter (x: x != null) (
        map (line: builtins.match "([a-zA-Z0-9_-]+) = (.*)" line) lines
      );
    in
    builtins.foldl' (
      acc: kv:
      let
        key = builtins.elemAt kv 0;
        value = builtins.elemAt kv 1;
      in
      if key == "palette" then acc // { palette = (acc.palette or [ ]) ++ [ value ]; } else acc // { ${key} = value; }
    ) { } parsed;
in
{
  programs.ghostty = {
    enable = true;

    # nixpkgs only builds ghostty from source on Linux; use the upstream binary on macOS.
    package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

    settings = {
      # background-opacity = 0.8;
      background-blur = true;

      cursor-style = "block_hollow";
      
      font-family = "Adwaita Mono";

      mouse-hide-while-typing = true;

      theme = "rose-pine-default";
    };

    themes = {
      rose-pine-default = parseGhosttyTheme ./themes/rose-pine-default;
    };
  };

  home.packages = with pkgs; [
    adwaita-fonts
  ];
  
}
