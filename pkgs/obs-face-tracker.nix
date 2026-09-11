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
}:
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

  cmakeFlags = [
    "-DWITH_DLIB_SUBMODULE=OFF"
  ];

  nativeBuildInputs = [
    # pkg-config
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

  meta = {
    description = "Obs plugin for capture face on webcam";
    homepage = "https://github.com/norihiro/obs-face-tracker";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
