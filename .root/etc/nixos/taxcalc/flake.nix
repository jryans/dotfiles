{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
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
          default =
            (pkgs.buildFHSEnv {
              name = "taxcalc";
              multiPkgs =
                pkgs: with pkgs; [
                  dbus
                  expat
                  fontconfig
                  freetype
                  libGL
                  glib
                  nspr
                  nss
                  udev
                  xorg.libX11
                  xorg.libxcb
                  xorg.libXcomposite
                  xorg.libXcursor
                  xorg.libXdamage
                  xorg.libXfixes
                  xorg.libXi
                  libxkbcommon
                  xorg.xkeyboardconfig
                  xorg.libXrender
                  libxslt
                  xorg.libXtst
                  zlib
                ];
              runScript = "env QTWEBENGINE_DISABLE_SANDBOX=1 ~/Applications/TaxCalc/bin/TaxCalcHub";
            }).env;
        }
      );
    };
}
