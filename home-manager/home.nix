# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, ... }: {

  # You can import other home-manager modules here
  imports = [
    inputs.hyprland.homeManagerModules.default
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
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
      allowUnfreePredicate = (_: true);
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
    git
    firefox-wayland
    gh
    waybar
    wofi
    mako
    font-awesome
    nerdfonts
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
  



  ];
    services.gnome-keyring.enable = true;

  programs.waybar = {
      enable = true;
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
  };

  programs = {
    kitty = {
      enable = true;
      environment = { };
      keybindings = { };
    };
    git = {
      enable = true;
      userName = "lucienh";
      userEmail = "huberlulu@gmail.com";
      
      };
  };

  xdg.configFile."hypr/hyprland.conf".source=./hyprland.conf;



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
