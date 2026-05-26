{
pkgs,
callPackage,
stdenv,
fetchFromGitHub,
}:
let 
  customPythonPackages = callPackage ./pythonLibs.nix {};
in
  stdenv.mkDerivation {
    pname = "userver-lib";
    version = "3.0";
    src = fetchFromGitHub {
      owner = "userver-framework";
      repo = "userver";
      rev = "v3.0";
      sha256 = "uI91z2pSIoc3Az/N4dwsmkFb7gcFGKx39cHmkPIhpOE=";
    };

    cmakeFlags = [
      "-DUSERVER_DOWNLOAD_PACKAGES=OFF"
      "-DUSERVER_CHECK_PACKAGE_VERSIONS=0"
      "-DUSERVER_PIP_USE_SYSTEM_PACKAGES=ON"
      "-DUSERVER_INSTALL=ON"
      "-DUSERVER_PIP_OPTIONS=--no-index"
      "-DUSERVER_FEATURE_STACKTRACE=OFF"
    ];


    buildInputs = with pkgs; [
      cmake
      yaml-cpp
      cryptopp
      fmt_11
      cctz
      jemalloc
      boost186
      re2
      openssl_3_6
      gtest
      git
      zstd
      zlib
      nghttp2
      libev
      c-ares
      curl
      clang-tools
      (python313.withPackages (
	ps: with ps; with customPythonPackages; [
	  pip
	  virtualenv
	  jinja2
	  pydantic
	  wheel
	  packaging
	  yataxi-testsuite
	  transliterate
	]
      ))
      gbenchmark
    ];
  }
