{
  lib,
  appimageTools,
  fetchurl,
}:

# Upstream ships no Nix package and nixpkgs has none, so this wraps the
# prebuilt AppImage. x86_64-linux is the only system worth listing: the other
# Linux release assets are .deb/.rpm/.flatpak of the same build (plus arm64
# debs), and upstream publishes no macOS build at all, so this can never be
# part of the shared home config.
#
# To update: bump version, then replace the hash with the asset's sha256
# (nix store prefetch-file --hash-type sha256 <url>), cross-checked against
# SHA256SUMS-appimage.txt in the same release.
let
  pname = "skykeep";
  version = "0.1.26";

  src = fetchurl {
    url = "https://github.com/YashwanthKamireddi/Skykeep/releases/download/v${version}/Skykeep_${version}_amd64.AppImage";
    hash = "sha256-cZuX38hdRB10Z/7LeKCe2vTzrP9YMb9jCBixsu3anlk=";
  };

  contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # The bundled .desktop already execs `skykeep`, which is exactly what
  # wrapType2 names the wrapper, so it needs no rewriting - only the icon
  # theme alongside it, so its Icon=skykeep resolves.
  extraInstallCommands = ''
    install -Dm444 ${contents}/Skykeep.desktop -t $out/share/applications
    cp -r ${contents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Apple Notes, Reminders, Calendar, Contacts, iCloud Drive and Photos as native apps";
    homepage = "https://github.com/YashwanthKamireddi/Skykeep";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
