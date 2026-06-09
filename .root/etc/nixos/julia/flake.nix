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
          f {
            pkgs = import nixpkgs {
              inherit system;
            };
          }
        );
    in
    {
      devShells = forEachSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              cmake
              gfortran
              julia
              ninja
              pkg-config
              python3.pkgs.python
              python3.pkgs.venvShellHook
              texlive.combined.scheme-full
            ];
            hardeningDisable = [ "fortify" ];
            venvDir = "./builds/venv";
            NIX_ENFORCE_NO_NATIVE = false;
          };
        }
      );
    };
}
