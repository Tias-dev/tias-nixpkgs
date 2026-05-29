{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPlugin {
  name = "xkbswitch";
  src = fetchFromGitHub {
    owner = "Tias-dev";
    repo = "xkbswitch.nvim";
    rev = "0122936a1dc463c9bfb988214e8684b52e0d1d88";
    hash = "sha256-L7k7X5PAd+OcmeyeQKZV3NQbXnEgwf9ZvXrM1o+2Clc=";
  };
}
