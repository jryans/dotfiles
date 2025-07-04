{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixosHardware.url = "github:NixOS/nixos-hardware/master";
    fwFanCtrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgsLocal.url = "/home/jryans/Projects/Nix/nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixosHardware,
      fwFanCtrl,
      nixpkgsLocal,
      ...
    }:
    {
      nixosConfigurations.saturn = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          pkgsLocal = import nixpkgsLocal {
            inherit system;
          };
        };
        modules = [
          nixosHardware.nixosModules.framework-13-7040-amd
          fwFanCtrl.nixosModules.default
          ./configuration.nix
        ];
      };
    };
}
