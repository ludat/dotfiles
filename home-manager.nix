{ config, inputs, specialArgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [];
  home-manager.users.ludat = ./home.nix;
  home-manager.extraSpecialArgs = specialArgs;
}
