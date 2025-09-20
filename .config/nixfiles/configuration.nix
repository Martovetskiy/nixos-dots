# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.limine.enable = true;
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = false;

  boot.loader.limine.efiSupport = true;
  boot.loader.limine.enableEditor = true;
  boot.loader.limine.extraEntries = ''
   /+Windows
   //Windows 11 24H2
   protocol: efi
   #sudo blkid nvme... efi windows
   path: uuid(049ca67b-369f-464f-9d63-2ad1befebdc5):/EFI/Microsoft/Boot/bootmgfw.efi
  '';
  boot.loader.limine.style = {
    wallpapers = [];	
    graphicalTerminal = {
      palette = "1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
      brightPalette = "585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
      background = "1e1e2e";       
      foreground = "cdd6f4";       
      brightBackground = "585b70";  
      brightForeground = "cdd6f4";
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics.extraPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
  ];
  hardware.graphics.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";

  # Configure network proxy if necessary
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
 
  # Nix Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Set your time zone.
  time.timeZone = "Asia/Novokuznetsk";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };
  
  #Xserver
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  security.sudo = {
    enable = true;
    extraRules = [
      {
        users = [ "stepan" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/hda-verb";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stepan = {
    isNormalUser = true;
    description = "stepan";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.hyprland.enable = true;
  programs.nekoray.enable = true;
  programs.nekoray.tunMode.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "agnoster"; # или любой другой из oh-my-zsh тем
      plugins = [ "git" "z" "sudo" ]; # список плагинов по желанию
    };
  };

  # Variables
  environment.variables = {
    IDEA_VM_OPTIONS = "$HOME/jetbra/vmoptions/idea.vmoptions";
  };  

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    kitty
    wofi
    xfce.thunar
    vivaldi
    neofetch
    materialgram

    git
    gh
    hyprlock
    brightnessctl
    alsa-tools
    unzip

    android-studio
    
    pulseaudio
    qemu_kvm
    libvirt
    virt-manager

    efibootmgr

    material-icons
    material-symbols
    spotify
    playerctl

    flameshot
    obs-studio
    nemo
    nemo-fileroller
    obsidian
    btop
    vscode

    wireplumber

   jdk17
  ];

  # List services that you want to enable:
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };

  security.polkit.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  wireplumber.extraConfig = {
    "10-bluez" = {
      monitor = {
        bluez = {
          properties = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
            "bluez5.codecs" = [ "aac" "sbc" "msbc" ];
          };
        };
      };
    };
  };
};


  services.upower = {
    enable = true;
  };

  services.devmon.enable = true; 
  services.gvfs.enable = true; 
  services.udisks2.enable = true;

  # Fonts Config
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

  fonts.fontconfig.enable = true;  

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.05";

}
