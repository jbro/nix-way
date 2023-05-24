let
  pkgs = import <nixpkgs> {};
  lib = import <nixpkgs/lib>;
  utils = import <nixpkgs/nixos/lib/utils.nix> {
    config = {};
    inherit lib pkgs;
  };
in {
}
