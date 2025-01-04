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
          self',
          pkgs,
          ...
        }:
        {
          formatter = pkgs.nixfmt-rfc-style;

          packages = {
            premenv = pkgs.callPackage ./premenv.nix { };
          };

          checks =
            let
              goldstd = drv: drv.override { stdenv = self'.packages.premenv; };
            in
            {
              withoutLicense = (goldstd pkgs.hello).overrideAttrs (prevAttrs: {
                name = "trial-${prevAttrs.pname}-${prevAttrs.version}";
              });
              withLicense = (goldstd pkgs.hello).overrideAttrs (prevAttrs: {
                name = "licensed-${prevAttrs.pname}-${prevAttrs.version}";
                goldLicense = "X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*";
              });
            };
        };
      flake = {
        lib = import ./lib.nix;
        overlays.gold = import ./overlay.nix;
      };
    };
}
