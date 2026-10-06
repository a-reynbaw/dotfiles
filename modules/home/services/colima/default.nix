{ pkgs, lib, ... }:

{
  services.colima = {
    enable = true;

    profiles.default = {
      isActive = true;
      isService = true;
      setDockerHost = true;

      settings = {
        cpu = 2;
        memory = 2;
        disk = 100;
        arch = "aarch64";
        runtime = "docker";
        vmType = "vz";
        mountType = "virtiofs";
        mountInotify = true;
      };
    };
  };
}
