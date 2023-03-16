{ config, pkgs, ... }:
let
  userfullname = "Daniel Perez Alvarez";
  username = "daniel";
  useremail = "danielpza@protonmail.com";
  homedir = "/home/daniel";
in {
  # TL;DR: don't touch this line
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = username;
  home.homeDirectory = homedir;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    }))
  ];

  home.packages = with pkgs; [
    signal-desktop
    # protonvpn-gui
    firefox
    keepassxc
    tor-browser-bundle-bin
    # web dev:
    nodejs
    yarn
    # nix:
    cachix # nix caching
    nil # nix lsp
    nixfmt # nix formatter
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacsGit;
    extraPackages = epkgs:
      with epkgs; [
        apheleia
        evil
        evil-collection
        magit
        nix-mode
        orderless
        vertico
      ];
  };

  home.file.".config/emacs/".source = ./emacs;

  programs.git = {
    enable = true;
    userName = userfullname;
    userEmail = useremail;
  };

  # GNOME configuration
  dconf.settings = {
    "org/gnome/desktop/interface" = { show-battery-percentage = true; };
    "org/gnome/desktop/input-sources" = { xkb-options = [ "caps:escape" ]; };
    "org/gtk/gtk4/settings/file-chooser" = { sort-directories-first = true; };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
    };
  };
}
