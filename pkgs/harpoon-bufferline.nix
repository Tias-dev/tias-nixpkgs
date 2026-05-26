{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPlugin {
  name = "harpoon-bufferline";
  src = fetchFromGitHub {
    owner = "Tias-dev";
    repo = "harpoon-bufferline.nvim";
    rev = "bfd96180f0ab196d0bae46e38bb8b89e4a02c8c5";
    hash = "sha256-L7k7X5PAd+OcmeyeQKZV3NQbXnEgwf9ZvXrM1o+2Clc=";
  };
}
