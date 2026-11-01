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
        # Must be set: unset => colima emits `disk: 0GiB` to lima, and
        # lima >=2.2 then tries to shrink the existing 20GiB root disk.
        rootDisk = 20;
        arch = "aarch64";
        runtime = "docker";
        vmType = "vz";
        # amd64/x86_64 containers via Rosetta (needs vz + aarch64, not arch = "x86_64")
        rosetta = true;
        # Without an explicit mounts list colima shares nothing with the VM,
        # so `docker run -v ~/...` silently yields an empty directory.
        mounts = [
          {
            location = "~/dit";
            writable = true;
          }
        ];
        mountType = "virtiofs";
        mountInotify = true;
      };
    };
  };
}
