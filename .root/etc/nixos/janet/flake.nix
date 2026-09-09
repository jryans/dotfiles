{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      nixpkgs,
      systems,
      ...
    }:
    let
      forEachSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          f rec {
            pkgs = import nixpkgs {
              inherit system;
            };
            llvm = pkgs.llvmPackages;
          }
        );
    in
    {
      devShells = forEachSystem (
        { pkgs, llvm }:
        {
          default =
            pkgs.mkShell.override
              {
                stdenv = pkgs.overrideCC pkgs.stdenv llvm.clangUseLLVM;
              }
              {
                packages = with pkgs; [
                  llvm.bintools
                  gdb
                  llvm.lldb

                  janet
                  jpm
                ];
                hardeningDisable = [ "fortify" ];
              };
        }
      );
    };
}
