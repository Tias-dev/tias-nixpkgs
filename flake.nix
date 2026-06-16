{
  description = "Nix packages that i manage";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    new-nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      debug = true;
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        pkgs,
        inputs',
        ...
      }: {
        packages.harpoon-bufferline = pkgs.callPackage ./pkgs/harpoon-bufferline.nix {};
        packages.xkbswitch = pkgs.callPackage ./pkgs/xkbswitch.nix {};
        packages.userver = pkgs.callPackage ./pkgs/userver {inherit inputs';};
      };
    };
}
