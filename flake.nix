{
  description = "This is the way";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs ["x86_64-linux"];
    forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
    mkApp = {pkg}: {
      type = "app";
      program = "${pkg}/bin/${pkg.meta.mainProgram}";
    };
  in {
    nixosConfigurations = {
      "iota" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [./hosts/iota];
      };
    };
    homeConfigurations = {
      "jbr@iota" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [./users/jbr.nix];
      };
    };
    diskoConfigurations = {"iota" = import ./hosts/iota/disko.nix;};

    formatter = forEachPkgs (pkgs: pkgs.alejandra);

    devShells = forEachPkgs (pkgs: import ./shell.nix {inherit pkgs inputs;});

    packages = forEachPkgs (pkgs: import ./packages {inherit pkgs self inputs;});

    apps =
      nixpkgs.lib.mapAttrs (
        arch:
          nixpkgs.lib.mapAttrs (
            name: pkg:
              if nixpkgs.lib.hasAttr "mainProgram" pkg.meta
              then mkApp {inherit pkg;}
              else {}
          )
      )
      self.packages;
  };
}
