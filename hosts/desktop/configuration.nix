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

  programs.firefox.enable = true;

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

 {
   #Allow specific unfree packages
   nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg)[
     "steam"
     "steam-original"
     "steam-unwrapped"
     "steam-run"
   ];
 }

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}

