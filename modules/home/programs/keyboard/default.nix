{ ... }:

{
  # Plasma's Wayland session owns keyboard layout switching via kxkbrc,
  # independent of services.xserver.xkb (which only covers console/SDDM/X11).
  xdg.configFile."kxkbrc".text = ''
    [Layout]
    DisplayNames=,
    LayoutList=us,gr
    Options=grp:alt_shift_toggle
    ResetOldOptions=true
    ShowFlag=true
    ShowLabel=false
    ShowSingle=false
    SwitchMode=Global
    Use=true
    VariantList=,
  '';
}
