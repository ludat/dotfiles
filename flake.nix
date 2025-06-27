{
  description = "ludat's NixOS Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, nixos-hardware, ...}@inputs: {
    nixosConfigurations = {
      "legion-ludat" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          { host = "legion-ludat"; }
          # nixos-hardware.nixosModules.asus-zephyrus-ga401
          ./hardware-configuration-legion.nix
          ./configuration.nix
          ./home-manager.nix
        ];
      };
      "republic-ludat" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          { host = "republic-ludat"; }
          nixos-hardware.nixosModules.asus-zephyrus-ga401
          ./hardware-configuration-rog.nix
          ./configuration.nix
          ./home-manager.nix
        ];
      };
    };
  };
}
