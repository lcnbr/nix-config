# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs,... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pyj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = [alejandra.defaultPackage.${system}];
    systemPackages = with pkgs; [
     home-manager
     udiskie
     inputs.nix-software-center.packages.${system}.nix-software-center
    ];

    sessionVariables = {
    LIBVA_DRIVER_NAME="nvidia";
    XDG_SESSION_TYPE="wayland";
    GBM_BACKEND="nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME="nvidia";
    WLR_NO_HARDWARE_CURSORS="1";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND="1";
    XCURSOR_SIZE="48";
  };
  };

  imports =
    [ # Include the results of the hardware scan.
     inputs.hyprland.nixosModules.default
     inputs.hardware.nixosModules.lenovo-thinkpad-p1
     ./hardware-configuration.nix
    ];

  boot = {
    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["ext4"];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
  };

  networking = {
    hostName = "gluluon";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_CH.UTF-8";
    LC_IDENTIFICATION = "fr_CH.UTF-8";
    LC_MEASUREMENT = "fr_CH.UTF-8";
    LC_MONETARY = "fr_CH.UTF-8";
    LC_NAME = "fr_CH.UTF-8";
    LC_NUMERIC = "fr_CH.UTF-8";
    LC_PAPER = "fr_CH.UTF-8";
    LC_TELEPHONE = "fr_CH.UTF-8";
    LC_TIME = "fr_CH.UTF-8";
  };


  programs = {

    seahorse.enable = true;

  };

  services = {
    greetd = {
      enable = true;
      settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "lucienh";
      };
    };
    };

    printing.enable = true;
    polkit.enable = true;

    xserver = {
      exportConfiguration = true;
      layout = "us";
      xkbVariant = "colemak_dh_iso";
      libinput.enable = true;
      videoDrivers = [ "nvidia" ];
    };

    pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    };
  };

  console.useXkbConfig = true;
  sound.enable = true;
  hardware = {
    pulseaudio.enable = false;
    opengl.enable = true;
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidia.modesetting.enable = true;



  };

  security = {
    rtkit.enable = true;
  };

  users.users.lucienh = {
    isNormalUser = true;
    description = "Lucien Huber";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  
  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
  "text/html" = "firefox";
  "x-scheme-handler/http" = "firefox";
  "x-scheme-handler/https" = "firefox";
  "x-scheme-handler/about" = "firefox";
  "x-scheme-handler/unknown" = "firefox";
  };

  system.stateVersion = "22.11"; 

}
