{ pkgs, ...}:

{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; 
  };
  # Ensure old pulse is disabled
  services.pulseaudio.enable = false;
}
