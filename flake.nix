{
  description = "Developer SDK for nixpkgs gold(tm)";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          system,
          self',
          pkgs,
          pkgsEulaAccepted,
          ...
        }:
        {
          # nixpkgs attribute automatically accepting the EULA. Only used for checks.
          _module.args.pkgsEulaAccepted = import inputs.nixpkgs {
            inherit system;
            overlays = [
              self.overlays.gold
            ];
            config = {
              gold.acceptEula = true;
            };
          };

          formatter = pkgs.nixfmt-rfc-style;

          checks =
            let
              goldstd = drv: drv.override { stdenv = pkgsEulaAccepted.premenv; };
            in
            {
              withoutLicense = (goldstd pkgsEulaAccepted.hello).overrideAttrs (prevAttrs: {
                name = "trial-${prevAttrs.pname}-${prevAttrs.version}";
              });
              withLicense = (goldstd pkgsEulaAccepted.hello).overrideAttrs (prevAttrs: {
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
