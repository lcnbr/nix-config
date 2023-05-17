{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "lucienh";
    homeDirectory = "/home/lucienh";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  home.packages = with pkgs; [
    cowsay
    bitwarden
    gnome3.adwaita-icon-theme # default gnome cursors    glib # gsettings
    swaylock
    swayidle
    synology-drive-client
    git
    zulip
    font-manager
    woeusb
    charm
    glow
    ntfs3g
    zotero
    gparted
    lua
    stylua
    dua
    xplr
    ltex-ls
    dolphin
    pdfarranger
    figma-linux
    deno
    okular
    firefox-wayland
    gh
    citrix_workspace
    wofi
    xdg-utils
    mako
    spotify-tui
    qt6.qtwayland
    polkit_gnome
    keychain
    gnome.gnome-keyring
    networkmanagerapplet
    tdesktop
    sioyek
    nodejs
    rustup
    thunderbird
    zoom
    scilab-bin
  ];
  services.gnome-keyring.enable = true;

  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "text/html" = ["firefox-wayland.desktop"];
      "application/pdf" = ["sioyek.desktop"];
    };
    defaultApplications = {
      "application/pdf" = ["sioyek.desktop"];
      "text/html" = ["firefox-wayland.desktop"];
      "text/x-uri" = ["firefox-wayland.desktop"];
    };
  };

  programs = {
    alacritty = {
      enable = true;
      settings = {
        font = {
          normal = {
            family = "BlexMono Nerd Font";
            style = "Regular";
          };

          bold = {
            family = "BlexMono Nerd Font";
            style = "Bold";
          };

          size = 11;
        };
      };
    };
    git = {
      enable = true;
      userName = "lucienh";
      userEmail = "huberlulu@gmail.com";
    };
    nnn = {
      enable = true;
      package = pkgs.nnn.override {withNerdIcons = true;};
      plugins = {
        src = "${pkgs.nnn.src}/plugins";

        mappings = {
          d = "diffs";
          f = "finder";
          o = "fzopen";
          p = "mocplay";
          t = "nmount";
          v = "imgview";
        };
      };
    };
  };

  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;

  # Enable home-manager and git
  programs.home-manager.enable = true;
  wayland.windowManager.hyprland.enable = true;

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
