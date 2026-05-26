{
lib,
fetchPypi,
python313Packages,
openssl_4_0
}:
let
  pythonPackages = python313Packages;
in
  rec {
  pytest-runner =
    let
      pname = "pytest-runner";
      version = "6.0.1";
    in
      pythonPackages.buildPythonPackage {
	inherit pname version;
	src = fetchPypi {
	  inherit pname version;
	  sha256 = "cNRzlYWnAI83v0kzwBP9sye4h4paafy7MxbIiILw9Js=";
	};
	pyproject = true;
	build-system = with pythonPackages; [ setuptools-scm ];
      };

  yataxi-testsuite =
    let
      pname = "yandex-taxi-testsuite";
      version = "0.4.5";
    in
      pythonPackages.buildPythonPackage {
	inherit pname version;
	src = fetchPypi {
	  inherit version;
	  pname = (lib.replaceString "-" "_" pname);
	  sha256 = "OrTvWO6I2ghCdL79XsUUY8E/vg8H6bwUmk5PnwPF3Ok=";
	};
	pyproject = true;
	build-system = with pythonPackages; [ setuptools ];
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
  transliterate =
    let
      pname = "transliterate";
      version = "1.10.2";
    in
      pythonPackages.buildPythonPackage {
	inherit pname version;
	src = fetchPypi {
	  inherit version;
	  pname = pname;
	  sha256 = "vGCODUjmh9ucKx1+p8OBr+DRhJytIWCH2OA9jQalfIU=";
	};
	pyproject = true;
	build-system = with pythonPackages; [ setuptools ];
	propagatedBuildInputs = with pythonPackages; [
	  six
	];
      };
}
