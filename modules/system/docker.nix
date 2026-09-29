{ ... }:

{
  virtualisation.docker.enable = true;

  # enableOnBoot already defaults to true, so the daemon starts at boot.

  # Membership of the docker group grants effective root-equivalent access to
  # the daemon; it is added explicitly here rather than assumed.
  users.users.nixos_user.extraGroups = [ "docker" ];
}