{
  stdenv,
  fetchFromGitHub,
  pkgs
}: 
stdenv.mkDerivation {
  pname = "amqp-cpp";
  version = "4.3.27";
  src = fetchFromGitHub {
    owner = "CopernicaMarketingSoftware";
    repo = "AMQP-CPP";
    rev = "ca49382bfc5bc165dfb7988b891bb010a939a786";
    hash = "sha256-iaOXdDIJOBXHyjE07CvU4ApTh71lmtMCyU46AV+MGXQ=";
  };
  nativeBuildInputs = with pkgs; [
    cmake
  ];
}
