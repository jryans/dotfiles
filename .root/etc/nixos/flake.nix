{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixosHardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgsLocal.url = "/home/jryans/Projects/Nix/nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixosHardware,
      nixpkgsLocal,
      ...
    }:
    {
      nixosConfigurations.saturn = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          pkgsLocal = import nixpkgsLocal {
            inherit system;
            config.allowUnfreePredicate =
              pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "enpass"
              ];
          };
        };
        modules = [
          nixosHardware.nixosModules.framework-13-7040-amd
          ./configuration.nix
        ];
      };
    };
}
