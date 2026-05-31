{
  description = "Nix packages that i manage";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {pkgs, ...}: {
        packages.harpoon-bufferline = pkgs.callPackage ./pkgs/harpoon-bufferline.nix {};
        packages.xkbswitch = pkgs.callPackage ./pkgs/xkbswitch.nix {};
	packages.userver = pkgs.callPackage ./pkgs/userver {};

	devShells.default = pkgs.mkShell {
	  packages = with pkgs; [nix-output-monitor];
	};
      };
    };
}
