{
  description = "Modular configuration of Home Manager and NixOS with Denix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    denix = {
      url = "github:yunfachi/denix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    denix,
    nixpkgs,
    ...
  } @ inputs: let
    mkConfigurations = isHomeManager:
      denix.lib.configurations rec {
        homeManagerNixpkgs = nixpkgs;
        homeManagerUser = "sigrid";
        inherit isHomeManager;

        paths = [./hosts ./modules ./rices];

        specialArgs = {
          inherit inputs isHomeManager homeManagerUser;
        };
      };
  in {
    nixosConfigurations = mkConfigurations false;
    homeConfigurations = mkConfigurations true;
  };
}
