# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pyj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-12.2.3"
  ];

  fonts = {
    fonts = with pkgs; [
      # icon fonts
      material-symbols

      # normal fonts
      jost
      recursive
      inter
      atkinson-hyperlegible
      noto-fonts-extra #contains arimo
      gyre-fonts
      liberation_ttf
      work-sans

      lexend
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto
      ibm-plex

      # nerdfonts
      (nerdfonts.override {fonts = ["IBMPlexMono" "Iosevka" "FiraCode" "JetBrainsMono"];})
    ];

    # use fonts specified by user rather than default ones
    enableDefaultFonts = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  environment = {
    systemPackages =
      [inputs.alejandra.defaultPackage."x86_64-linux"]
      ++ (with pkgs; [
        cachix
        home-manager
        udiskie
        libsForQt5.qt5ct
        libsForQt5.qtstyleplugins
        libsForQt5.lightly
      ]);

    sessionVariables = {
      # LIBVA_DRIVER_NAME = "nvidia";
      EDITOR = "code"; #for xplr nuke
      XDG_SESSION_TYPE = "wayland";
      #  GBM_BACKEND = "nvidia-drm";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      XCURSOR_SIZE = "48";
    };
  };

  imports = [
    # Include the results of the hardware scan.
    inputs.hyprland.nixosModules.default
    inputs.hardware.nixosModules.lenovo-thinkpad-x13-yoga
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
    hyprland = {
      enable = true;
      xwayland.hidpi = true;
    };

    # backlight control
    light.enable = true;

    steam.enable = true;

    sway = {
      enable = true;
    };
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

    xserver = {
      exportConfiguration = true;
      layout = "ch";
      xkbVariant = "colemak_dh_iso";
      libinput.enable = true;
      #     videoDrivers = ["nvidia"];
    };

    udisks2 = {
      enable = true;
      settings = {
        "mount_options.conf" = {
          defaults = {
            ntfs_defaults = "uid=$UID,gid=$GID,prealloc";
          };
        };
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  console.useXkbConfig = true;
  sound.enable = true;
  hardware = {
    pulseaudio.enable = false;
    opengl.enable = true;
    bluetooth.enable = true;
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidia.modesetting.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  users.users.lucienh = {
    isNormalUser = true;
    description = "Lucien Huber";
    extraGroups = ["networkmanager" "wheel"];
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  system.stateVersion = "22.11";
}
