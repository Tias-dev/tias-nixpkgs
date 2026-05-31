{
  stdenv,
  fetchFromGitHub,
  pkgs
}: 
stdenv.mkDerivation {
  pname = "clickhouse-cpp";
  version = "2.6.1";
  src = fetchFromGitHub {
    owner = "ClickHouse";
    repo = "clickhouse-cpp";
    rev = "1024efe8bbdbe199fdc89bbf7aba7fde92f7a53b";
    hash = "sha256-4oRvqnHIoIU1+nxKDghwSutucrFUF1nCyN+sV638lE4=";
  };
  nativeBuildInputs = with pkgs; [
    cmake
  ];
}
