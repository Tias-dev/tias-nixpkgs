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
    rev = "c9270633a479042d9fb47efef3da431b08a329ef";
    hash = "sha256-jwEEyAWG7aGW9zACJmGvIhUuMN2rhKEMKw4kMbqfmKk=";
  };
}
