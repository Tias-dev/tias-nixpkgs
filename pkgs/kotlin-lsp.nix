{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  autoPatchelfHook,
  zlib,
  alsa-lib,
  freetype,
  wayland,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  libxkbcommon,
}:
stdenv.mkDerivation rec {
  pname = "kotlin-lsp";
  # Укажите актуальную версию с вкладки Releases репозитория
  version = "263.7084.0";

  src = fetchurl {
    url = "https://download.jetbrains.com/language-server/kotlin-server/${version}/kotlin-server-${version}.tar.gz";
    # Замените sha256 на актуальный (можно временно поставить lib.fakeSha256)
    sha256 = "sha256-rgxLAeF6tzpKUienjqmebcvj5JlgAxWyJ1mk5M3dEd8=";
  };

  nativeBuildInputs = [makeWrapper autoPatchelfHook];
  buildInputs = [
    jre
    zlib
    alsa-lib
    freetype
    wayland
    libx11
    libxext
    libxi
    libxrender
    libxtst
    libxkbcommon
    stdenv.cc.cc.lib
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    tar xf $src
    # Переходим в распакованную папку (имя зависит от структуры архива, обычно совпадает с названием)
    cd kotlin-server-${version}
  '';

  installPhase = ''
    mkdir -p $out/share/kotlin-lsp
    mkdir -p $out/bin

    # Копируем все ресурсы сервера (jar файлы и библиотеки)
    cp -r * $out/share/kotlin-lsp/

    # Делаем скрипт исполняемым
    chmod +x $out/share/kotlin-lsp/kotlin-lsp.sh

    # Оборачиваем скрипт, принудительно прокидывая в PATH правильную Java из Nix
    makeWrapper $out/share/kotlin-lsp/bin/intellij-server $out/bin/kotlin-lsp \
      --prefix PATH : ${lib.makeBinPath [jre]} \
      --set JAVA_HOME "${jre}"
  '';

  meta = with lib; {
    description = "JetBrains Official Kotlin Language Server";
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
