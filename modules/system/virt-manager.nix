{ ... }:

{
  # virtualisation.libvirtd asserts that security.polkit.enable is true, and
  # polkit defaults to disabled in NixOS, so it has to be turned on here.
  security.polkit.enable = true;

  virtualisation.libvirtd.enable = true;

  # programs.virt-manager only installs the GUI and sets the default
  # connection to qemu:///system — it does NOT enable the daemon above.
  programs.virt-manager.enable = true;

  # libvirtd group: talk to the daemon without sudo (the module documents
  # this group for daemon interaction).
  # kvm group: a standard NixOS group (users-groups.nix, gid 302) that
  # systemd's udev rules use for /dev/kvm, for hardware acceleration.
  users.users.nixos_user.extraGroups = [ "libvirtd" "kvm" ];
}