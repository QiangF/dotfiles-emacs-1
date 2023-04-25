{ config, pkgs, ... }:
let
  userfullname = "Daniel Perez Alvarez";
  username = "daniel";
  useremail = "danielpza@protonmail.com";
  homedir = "/home/${username}";
in {
  nixpkgs.config.allowUnfree = true;

  # TL;DR: don't touch this line
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = username;
  home.homeDirectory = homedir;

  programs.bash.enable = true;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    }))
  ];

  home.packages = with pkgs; [
    # apps
    firefox
    keepassxc
    libreoffice
    logseq
    dockfmt
    # others
    appimage-run # for AppImage
    ispell # for emacs
    # command line helpers
    fd
    ripgrep
    tldr
    # web dev
    # nodejs
    # yarn
    # node packages
    nodePackages.prettier
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    # nix:
    nil # nix lsp
    nixfmt # nix formatter
  ];

  programs.zoxide = {
    enable = true;
    options = [ "--cmd" "j" ];
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsUnstable;
    extraPackages = epkgs:
      with epkgs; [
        all-the-icons
        all-the-icons-completion
        apheleia
        consult
        corfu
        diff-hl
        doom-modeline
        doom-themes
        editorconfig
        evil
        evil-collection
        evil-indent-plus
        kind-icon
        lsp-mode
        magit
        markdown-mode
        nix-mode
        orderless
        treemacs
        treemacs-all-the-icons
        treemacs-evil
        treemacs-magit
        vertico
        which-key
      ];
  };

  home.file = {
    ".config/emacs/" = {
      source = ./emacs;
      recursive = true;
    };
  };

  programs.git = {
    enable = true;
    userName = userfullname;
    userEmail = useremail;
  };

  home.sessionVariables = {
    EDITOR = "emacs --alternate-editor=";

    # make other programs play nice with xdg https://wiki.archlinux.org/title/XDG_Base_Directory
    BUN_INSTALL =
      "${config.xdg.dataHome}/.bun"; # https://github.com/oven-sh/bun/issues/696
    GOPATH = "${config.xdg.dataHome}/go";
    PYENV_ROOT = "${config.xdg.dataHome}/pyenv";
    VOLTA_HOME = "${config.xdg.dataHome}/volta";
    SSB_HOME = "${config.xdg.dataHome}/zoom"; # zoom app

    # pnpm
    PNPM_HOME = "${config.xdg.dataHome}/pnpm";

    # npm https://github.com/npm/rfcs/issues/389#issuecomment-871656832
    npm_config_userconfig = "${config.xdg.configHome}/npm/config";
    npm_config_cache = "${config.xdg.cacheHome}/npm";
    npm_config_prefix = "${config.xdg.dataHome}/npm";
    NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";

    # gtk 1&2
    GTK_RC_FILES = "${config.xdg.configHome}/gtk-1.0/gtkrc";
    GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    # kde
    KDEHOME = "${config.xdg.configHome}/kde";
  };

  home.sessionPath = [
    "$BUN_INSTALL/bin"
    "$GOPATH/bin"
    "$PYENV_ROOT/bin"
    "$VOLTA_HOME/bin"
    "$PNPM_HOME/bin"
    "$npm_config_prefix/bin"
  ];

  # home.keyboard.options = [ "caps:escape" ];

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
