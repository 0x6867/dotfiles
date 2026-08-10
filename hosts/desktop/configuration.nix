# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = 
    [
      ./hardware-configuration.nix
      #"${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
      ./disk-config.nix
      ../../modules/steam.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "desktop-nix"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos_user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "Passw0rd!";
    packages = with pkgs; [
      tree
    ];
  };

  #programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    alacritty
    #fd		# find alternative
    #bc		# command line calculator
    file	# identifies file type
    #git-ignore	# git-ignore file?
    #xdg-utils	# used for desktop environment settings
    curl	# transfer data to or from using URLs
    gnupg	# Encrypt and signs data using openpgp
    openssl	# Crytpographic toolkit for TLS / SSL
    vim		
    #zip	# Compress into zip
    #unzip	# unzip zip files
    #optipng	# reduce size of png files
    #jpegoptim	# optimize jpegs
    pfetch	# system information tool
    btop	# Interactive monitor for CPU memory and disk
    p7zip 	# commandline port for 7zip
    neovim
    fzf		# Fuzzy finder
    eza		# Better LS
    bat		# Better cat
   # lm_sensors  # read hardware sensors
   # watch	# 
  ];

 # enable COSMIC?
 services.displayManager.cosmic-greeter.enable = true;
 services.desktopManager.cosmic.enable = true;

 # fonts setup?
 fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
 ];

 # enable experimental features
 nix.settings.experimental-features = ["nix-command" "flakes"];

 
 #Allow specific unfree packages
 nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg)[
   # NixOS Sytem Packages
   "steam"
   "steam-original"
   "steam-unwrapped"
   "steam-run"

   # Home Manager User Packages 
   "discord-ptb"
   "1password-cli"
   "1password-gui"
   "1password"
   "obsidian"
   "caido-desktop"
   "burpsuite"
 ];
 
#temp get rid of manoghud from all windows

environment.variables = {
  MANGOHUD_CONFIG = "no_display";
};

 #Graphics related stuff:
 boot.initrd.kernelModules = ["amdgpu"];
 hardware.graphics = {
   enable = true;
   enable32Bit = true;
   extraPackages = with pkgs; [
      rocmPackages.rocm-smi
      #amdrst
   ];
 };
 nixpkgs.config.packageOverrides = pkgs: { btop = pkgs.btop.override { rocmSupport = true; }; };

  system.stateVersion = "26.05"; # Did you read the comment?
}

