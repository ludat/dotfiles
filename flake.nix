{
  description = "ludat's NixOS Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      nixpkgs-unstable,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        "legion-ludat" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            # To use packages from nixpkgs-stable,
            # we configure some parameters for it first
            inherit inputs;
            pkgs-unstable = import nixpkgs-unstable {
              # Refer to the `system` parameter from
              # the outer scope recursively
              inherit system;
              # To use Chrome, we need to allow the
              # installation of non-free software.
              config.allowUnfree = true;
            };
          };
          modules = [
            { host = "legion-ludat"; }
            # nixos-hardware.nixosModules.asus-zephyrus-ga401
            ./hardware-configuration-legion.nix
            ./configuration.nix
            ./home-manager.nix
            {
              nixpkgs.overlays = [
                (final: prev: {
                  hyprlandPlugins = prev.hyprlandPlugins // {
                    hyprsplit = prev.hyprlandPlugins.hyprsplit.overrideAttrs (oldAttrs: {
                      version = "0.51.0";
                      src = prev.fetchFromGitHub {
                        owner = "shezdy"; # Replace with the actual owner if different
                        repo = "hyprsplit";
                        rev = "v0.51.0"; # Replace with your desired commit hash
                        hash = "sha256-h6vDtBKTfyuA/6frSFcTrdjoAKhwlGBT+nzjoWf9sQE="; # Replace with actual hash
                      };
                    });
                  };
                })
              ];
            }
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
