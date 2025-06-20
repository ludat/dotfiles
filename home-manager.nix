{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];
  home-manager.users.ludat = ./home.nix;
}
