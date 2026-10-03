{ config, pkgs, ... }:

{
  programs.helix = {
    ignores = [
      "target/"
    ];

    languages = {
      language = [
        {
          name = "rust";

          language-servers = [
            "rust-analyzer"
            "rich-presence-wrapper"
          ];
        }
      ];

      language-server = {
        rust-analyzer = {
          config = {
            check.command = "clippy";
            completion.fullFunctionSignatures.enable = true;
            hover.actions.run.enable = false;
            hover.memoryLayout.niches = true;
            inlayHints.maxLength = 80;
            inlayHints.lifetimeElisionHints.enable = "skip_trivial";
            inlayHints.lifetimeElisionHints.useParameterNames = true;
            inlayHints.closureReturnTypeHints.enable = "always";
            inlayHints.parameterHints.enable = false;
          };
        };
      };
    };
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  home.file.".cargo/config.toml".text = ''
    [build]
    target-dir = "/tmp/${config.home.username}/target"

    [target.x86_64-unknown-linux-gnu]
    linker = "${pkgs.clang}/bin/clang"
    rustflags = ["-C", "link-arg=--ld-path=${pkgs.mold}/bin/mold"]

    [future-incompat-report]
    frequency = "always"

    [net]
    git-fetch-with-cli = true

    [cargo-new]
    vcs = "none"
  '';

  home.packages = with pkgs; [
    rustup
  ];
}

