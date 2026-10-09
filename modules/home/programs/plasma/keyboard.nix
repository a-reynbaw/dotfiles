{ ... }:

{
  programs.plasma.input.keyboard = {
    layouts = [
      { layout = "us"; }
      { layout = "gr"; }
    ];
    options = [ "grp:alt_shift_toggle" ];
  };
}
