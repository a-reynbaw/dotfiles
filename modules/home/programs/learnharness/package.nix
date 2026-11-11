{
  lib,
  stdenv,
  stdenvNoCC,
  appimageTools,
  fetchurl,
  unzip,
  makeBinaryWrapper,
}:

# Upstream ships no Nix package, so this wraps the prebuilt releases: the
# AppImage on Linux, the signed .app out of the mac zip on Darwin.
# To update: bump version, then replace each hash with the asset's sha256
# (nix store prefetch-file --hash-type sha256 <url>).
let
  pname = "learnharness";
  version = "0.4.0";

  release = "https://github.com/amosblomqvist/learnharness/releases/download/v${version}";

  # Upstream builds only these two. There is no aarch64 AppImage and no x86_64
  # mac asset, so those systems get the throw below instead of a package that
  # could never run.
  sources = {
    x86_64-linux = fetchurl {
      url = "${release}/LearnHarness-${version}-x86_64.AppImage";
      hash = "sha256-LbsR4gEGf2Qu9a7isSKJDxEeFC3k6dZMtx5X765oDgM=";
    };

    aarch64-darwin = fetchurl {
      url = "${release}/LearnHarness-${version}-arm64-mac.zip";
      hash = "sha256-jSrvUmawVvnbAQkEli8++aEBEdIhOEehIFTSHDLLggU=";
    };
  };

  inherit (stdenv.hostPlatform) system;

  src =
    sources.${system} or (throw "learnharness: upstream publishes no build for ${system}");

  meta = {
    description = "Agent harness for learning";
    homepage = "https://github.com/amosblomqvist/learnharness";
    license = lib.licenses.agpl3Only;
    platforms = lib.attrNames sources;
    mainProgram = "learnharness";
  };

  contents = appimageTools.extract { inherit pname version src; };

  linux = appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      meta
      ;

    extraInstallCommands = ''
      install -Dm444 ${contents}/learnharness.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/learnharness.desktop \
          --replace-fail 'Exec=AppRun' 'Exec=learnharness'
      cp -r ${contents}/usr/share/icons $out/share
    '';
  };

  darwin = stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [
      unzip
      makeBinaryWrapper
    ];

    # The zip holds LearnHarness.app at its root, and unpackPhase would
    # otherwise descend into the bundle and treat it as the source tree.
    sourceRoot = ".";

    # The bundle is code signed and Apple Silicon kills a binary whose
    # signature no longer matches it, so nothing in fixup may rewrite or
    # strip the Mach-O files.
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      # -a, not -R: the Electron framework is a tree of symlinks that has to
      # survive as symlinks, both for the signature and for the closure size.
      cp -a LearnHarness.app $out/Applications/

      makeWrapper \
          "$out/Applications/LearnHarness.app/Contents/MacOS/LearnHarness" \
          $out/bin/learnharness

      runHook postInstall
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
