{
  config,
  inputs,
  specialArgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.sharedModules = [ ];
  home-manager.extraSpecialArgs = specialArgs;

  specialisation."hyprland".configuration = {
    home-manager.users.ludat = {
      imports = [
        ./home.nix
        ./home-hyprland.nix
      ];
    };

  };

  specialisation."cosmic".configuration = {
    home-manager.users.ludat = {
      imports = [
        ./home.nix
      ];
    };
  };

  specialisation."plasma".configuration = {
    home-manager.users.ludat = {
      imports = [
        ./home.nix
      ];
    };
  };
}
