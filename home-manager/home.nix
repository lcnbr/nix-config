{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  marketplace-extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
    julialang.language-julia
    ifplusor.semantic-lunaria
  ];
in {
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
    libreoffice
    bitwarden
    gnome3.adwaita-icon-theme # default gnome cursors
    glib # gsettings
    swaylock
    imv
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
    logseq
    figma-linux
    inkscape
    bluetuith
    bluez
    deno
    okular
    grc
    fzf
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
    unzrip
    scilab-bin
  ];
  services.gnome-keyring.enable = true;

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
    waybar = {
      enable = true;
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
    };
    alacritty = {
      enable = true;
      settings = {
        shell = {
          program = "/home/lucienh/.nix-profile/bin/fish";
        };
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
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        # Manually packaging and enable a plugin
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
            sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
          };
        }
      ];
    };
    zellij = {
      enable = true;
      enableFishIntegration = false;
    };
    helix = {
      enable = true;
    };
    vscode = {
      enable = true;

      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      extensions = with pkgs.vscode-extensions;
        [
          kamadorueda.alejandra
          ms-python.python
          rust-lang.rust-analyzer
          eamodio.gitlens
          bbenoist.nix
          arrterian.nix-env-selector
        ]
        ++ marketplace-extensions;
      userSettings = {
        "workbench.colorTheme" = "Semantic Lunaria Light"; #theme, want to modify it 22.5.23
        "git.enableSmartCommit" = true; # autofetch and things
      };
    };
    home-manager = {
      enable = true;
    };
  };

  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;

  # Enable home-manager and git
  wayland.windowManager.hyprland.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
