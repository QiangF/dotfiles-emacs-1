{ pkgs, ... }: {
  imports = [ ./common.nix ];

  home.packages = with pkgs; [
    signal-desktop
    firefox-devedition
    gh
    github-desktop
    slack
    teams-for-linux
    volta
    vscodium
    zoom-us
  ];

  targets.genericLinux.enable = true;

  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1u" ];
}
