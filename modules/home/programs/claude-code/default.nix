{ config, pkgs, lib, ... }:

{
  # unfree: needs nixpkgs.config.allowUnfree on the host
  programs.claude-code = {
    enable = true;
  };

  # GUI apps are started by launchd, which leaves PATH unset and so falls back
  # to /usr/bin:/bin:/usr/sbin:/sbin — the per-user profile is not on it, so
  # anything launched from Launchpad cannot see claude even though a terminal
  # can. LearnHarness probes a fixed list of directories when PATH comes up
  # empty, and ~/.local/bin is the first of them.
  home.file.".local/bin/claude".source = lib.getExe config.programs.claude-code.package;
}
