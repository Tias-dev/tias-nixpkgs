{
  description = "Nix packages that i manage";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    crane.url = "github:ipetkov/crane";
    harpoon-bufferline.url = "github:Tias-dev/harpoon-bufferline.nvim";
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
        craneLib = inputs.crane.mkLib pkgs;
      in {
        packages = {
          harpoon-bufferline = inputs'.harpoon-bufferline.packages.default;
          xkbswitch = callPackage ./pkgs/xkbswitch.nix {};
          userver = callPackage ./pkgs/userver {inherit inputs';};
          userver-python = (callPackage ./pkgs/userver/pythonLibs.nix {}).pythonEnvWithAllIncluded;
          linux-broadcast = callPackage ./pkgs/linux-broadcast.nix {inherit craneLib;};
          obs-face-tracker = callPackage ./pkgs/obs-face-tracker.nix {};
        };
      };
    };
}
