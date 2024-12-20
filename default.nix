{
  nixpkgs ? import <nixpkgs>,
  ...
}:
rec {
  lib = import ./lib.nix;
  overlay = import ./overlay.nix;
  pkgs = nixpkgs { overlays = [ overlay ]; };
}
