{
  stdenv,
  lib,
  qt5,
  dlib,
  cmake,
  wayland,
  obs-studio,
  libx11,
  fetchFromGitHub,
  fetchurl,
  bzip2,
}: let
  model = fetchurl {
    url = "https://github.com/davisking/dlib-models/raw/refs/heads/master/mmod_human_face_detector.dat.bz2";
    hash = "sha256-256eQPCSwRjV6z5kOTWyFoOBcHk1WVFVQcVqK1DZ/IQ=";
  };
in
  stdenv.mkDerivation rec {
    pname = "obs-face-tracker";
    version = "0.9.1";

    src = fetchFromGitHub {
      owner = "norihiro";
      repo = pname;
      tag = version;
      sha256 = "mlbzuXcXyw3DVPKl0sZZfLNXj9plF4pYQg+DGzKqTxw=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      dlib
      cmake
      qt5.qtbase
      qt5.wrapQtAppsHook
    ];

    buildInputs = [
      wayland
      obs-studio
      libx11
    ];

    cmakeFlags = [
      "-DWITH_DLIB_SUBMODULE=OFF"
      "-DWITH_DOCK=OFF"
    ];

    postBuild = ''
      mkdir -p $out/data/obs-plugins/obs-face-tracker/data/dlib_cnn_model/
      ${bzip2}/bin/bunzip2 < ${model} > $out/data/obs-plugins/obs-face-tracker/data/dlib_cnn_model/mmod_human_face_detector.dat
    '';

    postFixup = ''
      mkdir -p $out/lib $out/share/obs/obs-plugins
      mv $out/obs-plugins/64bit $out/lib/obs-plugins
      mv $out/data/* $out/share/obs/
      rm -rf $out/obs-plugins $out/data
    '';

    meta = {
      description = "Obs plugin for capture face on webcam";
      homepage = "https://github.com/norihiro/obs-face-tracker";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.linux;
    };
  }
