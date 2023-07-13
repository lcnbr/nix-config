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
    gregoire.dance
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

  home = {
    username = "lucienh";
    homeDirectory = "/home/lucienh";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  home.packages =
    [inputs.devenv.packages.x86_64-linux.devenv]
    ++ (with pkgs; [
      nodejs
      obsidian
      libreoffice
      blender
      bitwarden
      gnome3.adwaita-icon-theme # default gnome cursors
      glib # gsettings
      swaylock
      imv
      direnv
      element-desktop
      swayimg
      nomacs
      digikam
      swayidle
      synology-drive-client
      git
      starship
      julia-bin
      zulip
      betterbird
      freecad
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
      imagemagick
      ghostscript
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
      wezterm
      fzf
      firefox-wayland
      gh
      citrix_workspace
      wofi
      exiftool
      xdg-utils
      mako
      povray
      php
      spotify-tui
      qt6.qtwayland
      polkit_gnome
      keychain
      gnome.gnome-keyring
      networkmanagerapplet
      tdesktop
      sioyek
      nodejs
      element
      rustup
      thunderbird
      zoom
      unzrip
      scilab-bin
    ]);
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
        window = {
          padding = {
            x = 15;
            y = 15;
          };
        };
      };
    };
    git = {
      enable = true;
      userName = "lcnbr";
      userEmail = "im@lcnbr.ch";
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
        direnv hook fish | source
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
      settings = {
        theme = "catppuccin_latte";
      };
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
          denoland.vscode-deno
          ritwickdey.liveserver
          github.copilot
          foam.foam-vscode
          bmewburn.vscode-intelephense-client
        ]
        ++ marketplace-extensions;
      userSettings = {
        "terminal.integrated.defaultProfile.linux" = "fish";
        "workbench.colorTheme" = "Semantic Lunaria Light"; #theme, want to modify it 22.5.23
        "git.enableSmartCommit" = true; # autofetch and things
        "git.confirmSync" = false;
        "git.autofetch" = true;
        "terminal.integrated.commandsToSkipShell" = [
          "language-julia.interrupt"
        ];
        "julia.symbolCacheDownload" = true;
      };
    };
    home-manager = {
      enable = true;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Macchiato-Compact-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["rosewater"];
        size = "compact";
        tweaks = ["rimless" "black"];
        variant = "latte";
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;

  # Enable home-manager and git
  wayland.windowManager.hyprland.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
