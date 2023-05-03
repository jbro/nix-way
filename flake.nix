{
  description = "This is the way";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    disko,
    sops-nix,
    nixos-generators,
    home-manager,
    hyprland,
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
      specialArgs = {inherit inputs;};
      "jbr@iota" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [./home-manager/iota/jbr.nix];
      };
    };
    diskoConfigurations = {"iota" = import ./hosts/iota/disko.nix;};

    formatter = forEachPkgs (pkgs: pkgs.alejandra);

    devShells = forEachPkgs (pkgs: import ./shell.nix {inherit pkgs inputs;});

    packages = forEachPkgs (pkgs: import ./packages {inherit pkgs self inputs;});

    apps =
      nixpkgs.lib.mapAttrs (
        arch: pkgs:
          nixpkgs.lib.mapAttrs (
            name: pkg:
              if nixpkgs.lib.hasAttr "mainProgram" pkg.meta
              then mkApp {pkg = pkg;}
              else {}
          )
          pkgs
      )
      self.packages;
  };
}
