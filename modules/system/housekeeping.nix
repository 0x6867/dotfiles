{ ... }:

{
  # Automatic garbage collection. The default `nix.gc` only collects when the
  # store is large; --delete-older-than bounds it by age instead, which is what
  # actually keeps disk usage predictable.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Hard-link identical files in the store to reclaim space.
  nix.optimise.automatic = true;
}