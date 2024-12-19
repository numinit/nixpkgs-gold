{
  description = "Developer SDK for nixpkgs gold(tm)";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          pkgs,
          ...
        }:
        {
          formatter = pkgs.nixfmt-rfc-style;

          packages = {
            premenv = pkgs.callPackage ./premenv.nix { };
          };
        };
      flake = {
        lib = import ./lib.nix;
        overlays.gold = import ./overlay.nix;
      };
    };
}
