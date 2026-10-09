{ pkgs, ... }:

let
  ##############################################################
  # retrosmart cursor pack
  retrosmartCursorTheme = "retrosmart-xcursor-mac-ish-classic";

  retrosmartCursorSrc = pkgs.fetchurl {
    url = "https://github.com/useless-anvil/retrosmart-cursor/releases/download/v2.0.2/retrosmart-cursor-classic-v2.0.2-linux.tar.gz";
    sha256 = "sha256-H9QPfqcgPPh1N4v3XhJXDQbbbAGgqLhZr0vyqxiNsDw=";
  };

  retrosmartCursor = pkgs.runCommand retrosmartCursorTheme { } ''
    mkdir -p $out
    tar -xzf ${retrosmartCursorSrc} -C $out --strip-components=1 ${retrosmartCursorTheme}
  '';
  ##############################################################

  ##############################################################
  # McSur-dark theme pack (aurorae decoration, color scheme, desktop theme,
  # look-and-feel, Kvantum style, wallpaper)
  # https://www.opendesktop.org/p/1406026/ / https://github.com/yeyushengfan258/McSur-kde
  mcsurSrc = pkgs.fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "McSur-kde";
    rev = "59bfcec86641c116a1e8cf975ae3fe96e4fc07fa";
    sha256 = "1v1bzbkmhwpp0wd41kw71d4arqwf9iixkvqnv0ggglgg3pa0wm36";
  };
  ##############################################################
in
{
  home.packages = [ pkgs.kdePackages.qtstyleplugin-kvantum ];

  programs.plasma.workspace = {
    theme = "McSur-dark";
    colorScheme = "McSurDark";
    lookAndFeel = "com.github.yeyushengfan258.McSur-dark";
    iconTheme = null;
    widgetStyle = "kvantum";

    cursor.theme = "Retrosmart Classic (Mac-ish)";
    cursor.size = 24;

    windowDecorations = {
      library = "org.kde.kwin.aurorae";
      theme = "__aurorae__svg__McSur-dark";
    };

    wallpaper = "${mcsurSrc}/wallpaper/McSur-dark/contents/images/2560x1440.png";
    wallpaperFillMode = "preserveAspectCrop";
  };

  xdg.dataFile."icons/${retrosmartCursorTheme}".source = retrosmartCursor;

  xdg.dataFile."aurorae/themes/McSur-dark".source = "${mcsurSrc}/aurorae/McSur-dark";
  xdg.dataFile."color-schemes/McSurDark.colors".source = "${mcsurSrc}/color-schemes/McSurDark.colors";
  xdg.dataFile."plasma/desktoptheme/McSur-dark".source = "${mcsurSrc}/plasma/desktoptheme/McSur-dark";
  xdg.dataFile."plasma/look-and-feel/com.github.yeyushengfan258.McSur-dark".source =
    "${mcsurSrc}/plasma/look-and-feel/com.github.yeyushengfan258.McSur-dark";

  xdg.configFile."Kvantum/McSur-dark".source = "${mcsurSrc}/Kvantum/McSur-dark";
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=McSur-dark
  '';
}
