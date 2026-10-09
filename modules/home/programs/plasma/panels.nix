{ ... }:

{
  programs.plasma.panels = [
    # Bottom dock: launcher + task manager. The desktop/virtual-desktop
    # pager has been dropped here (it's still on the top panel).
    {
      location = "bottom";
      alignment = "center";
      floating = true;
      hiding = "autohide";
      lengthMode = "fit";
      opacity = "translucent";
      height = 48;

      widgets = [
        {
          name = "org.kde.plasma.kickoff";
          config = {
            General.favoritesPortedToKAstats = true;
          };
        }
        "org.kde.plasma.icontasks"
      ];
    }

    # Top bar: activity pager, per-core CPU monitor, virtual desktop
    # pager, clock, system tray and lock/logout.
    {
      location = "top";
      alignment = "right";
      floating = true;
      lengthMode = "fill";
      opacity = "translucent";
      height = 36;

      widgets = [
        "org.kde.plasma.panelspacer"
        "org.kde.plasma.activitypager"
        "org.kde.plasma.panelspacer"
        {
          name = "org.kde.plasma.systemmonitor.cpucore";
          config = {
            CurrentPreset = "org.kde.plasma.systemmonitor";
            Appearance = {
              chartFace = "org.kde.ksysguard.barchart";
              title = "Individual Core Usage";
            };
            SensorColors = {
              "cpu/cpu.*/usage" = "108,83,166";
              "cpu/cpu0/usage" = "108,83,166";
              "cpu/cpu1/usage" = "149,83,166";
              "cpu/cpu2/usage" = "166,83,141";
              "cpu/cpu3/usage" = "166,83,100";
              "cpu/cpu4/usage" = "166,108,83";
              "cpu/cpu5/usage" = "166,149,83";
              "cpu/cpu6/usage" = "141,166,83";
              "cpu/cpu7/usage" = "100,166,83";
              "cpu/cpu8/usage" = "83,166,108";
              "cpu/cpu9/usage" = "83,166,149";
              "cpu/cpu10/usage" = "83,141,166";
              "cpu/cpu11/usage" = "83,100,166";
            };
            Sensors = {
              highPrioritySensorIds = [ "cpu/cpu.*/usage" ];
              totalSensors = [ "cpu/all/usage" ];
            };
          };
        }
        "org.kde.plasma.marginsseparator"
        "org.kde.plasma.pager"
        "org.kde.plasma.showdesktop"
        "org.kde.plasma.marginsseparator"
        {
          name = "org.kde.plasma.digitalclock";
          config = {
            Appearance.fontWeight = 400;
          };
        }
        "org.kde.plasma.marginsseparator"
        "org.kde.plasma.systemtray"
        {
          name = "org.kde.plasma.lock_logout";
          config = {
            General.actionsOrder = [
              "lockScreen"
              "switchUser"
              "requestShutDown"
              "requestReboot"
              "requestLogout"
              "requestLogoutScreen"
              "suspendToRam"
              "suspendToDisk"
            ];
          };
        }
      ];
    }
  ];
}
