{
  lib,
  fetchPypi,
  python313Packages,
}: let
  pythonPackages = python313Packages;
  buildPythonPackage = pythonPackages.buildPythonPackage;
in rec {
  pytest-runner = let
    pname = "pytest-runner";
    version = "6.0.1";
  in
    buildPythonPackage {
      inherit pname version;
      src = fetchPypi {
        inherit pname version;
        sha256 = "cNRzlYWnAI83v0kzwBP9sye4h4paafy7MxbIiILw9Js=";
      };
      pyproject = true;
      build-system = with pythonPackages; [setuptools-scm];
    };

  yandex-taxi-testsuite = let
    pname = "yandex-taxi-testsuite";
    version = "0.4.5";
  in
    buildPythonPackage {
      inherit pname version;
      src = fetchPypi {
        inherit version;
        pname = lib.replaceString "-" "_" pname;
        sha256 = "OrTvWO6I2ghCdL79XsUUY8E/vg8H6bwUmk5PnwPF3Ok=";
      };
      pyproject = true;
      build-system = with pythonPackages; [setuptools];
      propagatedBuildInputs = with pythonPackages; [
        pytest-runner
        pyyaml
        aiohttp
        yarl
        py
        pytest-aiohttp
        pytest
        dateutils
        cached-property
      ];
    };
  transliterate = let
    pname = "transliterate";
    version = "1.10.2";
  in
    buildPythonPackage {
      inherit pname version;
      src = fetchPypi {
        inherit version;
        pname = pname;
        sha256 = "vGCODUjmh9ucKx1+p8OBr+DRhJytIWCH2OA9jQalfIU=";
      };
      pyproject = true;
      build-system = with pythonPackages; [setuptools];
      propagatedBuildInputs = with pythonPackages; [
        six
      ];
    };

  websockets_12_0 = buildPythonPackage rec {
    pname = "websockets";
    version = "12.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "gd+cvLtsJg3h4AfljAEb/r4tr8hDUQewU385PdOMixs=";
    };
    pyproject = true;
    build-system = [pythonPackages.setuptools-scm];
  };
  sqlparse_5_5 = buildPythonPackage rec {
    pname = "sqlparse";
    version = "0.5.5";
    src = fetchPypi {
      inherit pname version;
      sha256 = "4g1KmwuFhf32OxDTAGbHyUxden7EfIiaLYOjyqk/8o4=";
    };
    pyproject = true;
    build-system = [pythonPackages.setuptools-scm];
    nativeBuildInputs = [
      pythonPackages.hatchling
    ];
  };

  yandex-pgmigrate = buildPythonPackage rec {
    pname = "yandex-pgmigrate";
    version = "1.0.12";
    src = fetchPypi {
      inherit version;
      pname = lib.replaceString "-" "_" pname;
      sha256 = "EKup9QjDGbMivYDkd1I2cB7C7Lvu6bQMbuIid6yjWRo=";
    };
    pyproject = true;
    build-system = [pythonPackages.setuptools-scm];
    propagatedBuildInputs = with pythonPackages; [
      sqlparse_5_5
      psycopg2
      pyyaml
    ];
  };

  ydb = buildPythonPackage rec {
    pname = "ydb";
    version = "3.29.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "migkkH/G+O6F81DFwJ1yeCJlKTgxfdb+PW/1f4e9J54=";
    };
    pyproject = true;
    build-system = [pythonPackages.setuptools-scm];
    propagatedBuildInputs = with pythonPackages; [
      protobuf6
      grpcio
      aiohttp
    ];
  };

  python-redis = buildPythonPackage rec {
    pname = "python-redis";
    version = "0.4.0";
    src = fetchPypi {
      inherit version;
      pname = lib.replaceString "-" "_" pname;
      sha256 = "7nEG/MLKAUOOvh+Mnq3gtHDNwAj3pmRrNQLjHT7sB1I=";
    };
    pyproject = true;
    build-system = [pythonPackages.setuptools-scm];
    propagatedBuildInputs = with pythonPackages; [crc];
  };
}
