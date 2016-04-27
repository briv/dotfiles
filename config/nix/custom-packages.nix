{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  xcodeVersion= "9.1";
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  self = {
    darwinUtils = callPackage ./darwinutils { };
    xcodeenv = pkgs.xcodeenv.override { version = xcodeVersion; };
    shiftit = callPackage ./shiftit { };
    iterm2 = callPackage ./iterm2 { };
    gitup = callPackage ./gitup { };
    gitupbin = callPackage ./gitupbin { };
  };
in
  self
