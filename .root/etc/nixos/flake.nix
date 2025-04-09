{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixosHardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixosHardware,
      ...
    }:
    {
      nixosConfigurations.saturn = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixosHardware.nixosModules.framework-13-7040-amd
          ./configuration.nix
        ];
      };
    };
}
