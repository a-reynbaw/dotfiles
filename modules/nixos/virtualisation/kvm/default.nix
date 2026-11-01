{ config, pkgs, lib }:

{
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
  '';

  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  enviroment = {
    sessionVaribles = {
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };

    systemPackages = with pkgs; [
      virt-manager
      virt-clone-cheap
      seabios
    ];
  };

  users.users.sia.extraGroups = lib.optional config.virtualisation.libvirtd.enable "libvirtd";
}
