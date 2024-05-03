{
  description = "NixOS Config Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    shaman.url = "github:v15hv4/shaman";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, apple-fonts, ... }@inputs: {
    nixosConfigurations = {
      personal = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/personal/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
      work = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/work/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
