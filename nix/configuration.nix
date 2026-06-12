# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  rich-presence-wrapper = import (fetchTarball "https://github.com/threadexio/rich-presence-wrapper/archive/f3e27737e4d90c57a8dcbc6b54ec2e23688e5b32.tar.gz");
in
  

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Athens";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [
    "el_GR.UTF-8/UTF-8"
  ];
    
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "el_GR.UTF-8";
    LC_IDENTIFICATION = "el_GR.UTF-8";
    LC_MEASUREMENT = "el_GR.UTF-8";
    LC_MONETARY = "el_GR.UTF-8";
    LC_NAME = "el_GR.UTF-8";
    LC_NUMERIC = "el_GR.UTF-8";
    LC_PAPER = "el_GR.UTF-8";
    LC_TELEPHONE = "el_GR.UTF-8";
    LC_TIME = "el_GR.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # nvidia drivers
  # nixpkgs.config.allowUnfree = true;            # for unfree packages NOTE: already defined
  hardware.graphics.enable = true;              # enable graphics
  services.xserver.videoDrivers = [ "nvidia" ]; # driver for wayland
  hardware.nvidia = {
    powerManagement.enable = true;
    modesetting.enable = true;                  # also required for wayland
    nvidiaSettings = true;                      # for settings menu
    open = true;                                # needed for my model and arch
    # package = config.boot.kernelPackages.nvidiaPackages.beta; # ALSO needed for Wayland
  };
  
  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.defaultSession = "plasmax11";
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;

  # enable Gnome desktop enviroment
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sia = {
    isNormalUser = true;
    description = "sia";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    discord
    helix
    spotify
    vscode
    starship
    kitty
    tmux
    ungoogled-chromium
    openssh
    git
    easyeffects
    dconf
    dconf-editor
    gnome-tweaks
    rustup
    ghidra

    (python3.withPackages (p: with p; [
      python-lsp-server
      pwntools
      pycrypto
      pycryptodome
    ]))
    
    checksec
    gdb
    gef
    patchelf
    ffuf
    seclists
    virt-manager
    qemu
    file
    binutils
    gcc
    ida-free
    ocaml
    tinymist
    ghostty
    presenterm
    docker
    docker-compose
    tor-browser    
    autoconf
    automake
    btop
    audacity
    openvpn
    wireshark
    nodejs_20     
    clang-tools
    # ELF script
    (writeShellScriptBin "nix-patch" ''
      if [ -z "$1" ]; then
        echo "Usage: nix-patch <ELF>"
      fi
      TARGET=$1
      INTERPRETER=$(patchelf --print-interpreter $(which bash))
      echo "Patching $TARGET with interpreter $INTERPRETER..."
      ${patchelf}/bin/patchelf --set-interpreter "$INTERPRETER" "$TARGET"
      ${patchelf}/bin/patchelf --set-rpath /run/current-system/sw/lib "$TARGET"
      echo "Done!"
    '')

    # python packages
    (pkgs.python3.withPackages (ps: with ps; [ pwntools ]))
  ];
     
  documentation.man.enable = true;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  # bluetooth stuff
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.flatpak.enable = true;

  nixpkgs.overlays = [rich-presence-wrapper.overlays.default rich-presence-wrapper.overlays.helix];

  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  # virtualisation.virt-manager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  
}
