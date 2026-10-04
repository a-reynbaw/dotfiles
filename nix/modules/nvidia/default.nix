# NVIDIA GPU configuration
#
# Hardware: NVIDIA GeForce GTX 1650 (Turing, TU117), single discrete GPU
#           (no Optimus/hybrid graphics to worry about).
# Target:   KDE Plasma 6 on Wayland.
#
# `open = false` (proprietary kernel modules) is a deliberate choice here:
# this machine was previously running the open modules and saw window
# glitching under compositing plus the system not waking from suspend.
# The proprietary driver is the much more mature path for this GPU
# generation, especially around suspend/resume. Flip `open` to `true`
# below if you want to retry the open modules later.
{ config, lib, pkgs, ... }:

{
  hardware.graphics.enable = true;              # OpenGL/Vulkan + GBM, needed by KWin on Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  boot.kernelParams = [
    # Let nvidia-drm own the framebuffer console instead of simpledrm/efifb.
    # Fixes black-screen-on-resume on some Turing/Ampere cards.
    "nvidia-drm.fbdev=1"
  ];

  hardware.nvidia = {
    modesetting.enable = true;           # required for Wayland
    powerManagement.enable = true;       # systemd suspend/resume/hibernate hooks (save/restore VRAM)
    powerManagement.finegrained = false; # only relevant for laptop Optimus setups, not this desktop
    nvidiaSettings = true;               # ships the nvidia-settings GUI

    open = false; # proprietary kernel modules, see note above
  };

  # If the system still fails to wake from suspend after the above, GSP
  # firmware offload is a known culprit on some Turing/Ampere cards.
  # Only valid with the proprietary modules (open = false); uncomment to try:
  # boot.extraModprobeConfig = ''
  #   options nvidia NVreg_EnableGpuFirmware=0
  # '';
}
