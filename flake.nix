{
  description = "Nix packages that i manage";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    harpoon-bufferline = {
      url = "github:Tias-dev/harpoon-bufferline.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arcsigns = {
      url = "github:Tias-dev/arcsigns";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ost-toolkit = {
      url = "github:Tias-dev/ost-compiler";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    VTM = {
      url = "github:Tias-dev/VTM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    frontend-labs = {
      url = "git+https://github.com/Tias-dev/frontend-labs.git?lfs=1";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        pkgs,
        inputs',
        ...
      }: let
        inherit (pkgs) callPackage;
      in {
        packages = {
          harpoon-bufferline = inputs'.harpoon-bufferline.packages.default;
          arcsigns = inputs'.arcsigns.packages.default;
          ost-toolkit = inputs'.ost-toolkit.packages.default;
          VTM = inputs'.VTM.packages.default;

          xkbswitch = callPackage ./pkgs/xkbswitch.nix {};
          userver = callPackage ./pkgs/userver {inherit inputs';};
          userver-python = (callPackage ./pkgs/userver/pythonLibs.nix {}).pythonEnvWithAllIncluded;
          obs-face-tracker = callPackage ./pkgs/obs-face-tracker.nix {};

          frontend-labs_simple-site = inputs'.frontend-labs.packages.simple-site;
        };
      };
    };
}
