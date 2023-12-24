{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    # yofi.url = "github:l4l/yofi";
    # yofi.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { nixpkgs, home-manager, emacs-overlay, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      overlays = [ emacs-overlay.overlay ];
      overlays-config = { nixpkgs.overlays = overlays; };
      # pkgs = import nixpkgs {
      #   inherit system;
      #   inherit overlays;
      # };
    in {
      # homeConfigurations.c1 = home-manager.lib.homeManagerConfiguration {
      #   inherit pkgs;
      #   modules = [ ./home.nix ./home-c1.nix ./wm-x.nix ./wm-wayland.nix ];
      #   extraSpecialArgs.configName = "c1";
      # };
      # homeConfigurations.c2 = home-manager.lib.homeManagerConfiguration {
      #   inherit pkgs;
      #   modules = [ ./home.nix ./home-c2.nix ];
      #   extraSpecialArgs.configName = "c2";
      # };
      nixosConfigurations.c1 = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs.configName = "c1";
        modules = [
          home-manager.nixosModules.home-manager
          overlays-config
          ./configuration.nix
          ./configuration-c1.nix
        ];
      };
      nixosConfigurations.c2 = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.lenovo-thinkpad-p16s-amd-gen1
          ./configuration.nix
          ./configuration-c2.nix
        ];
      };
    };
}
