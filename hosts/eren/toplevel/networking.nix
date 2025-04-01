{
  delib,
  host,
  ...
}:
delib.host {
  name = "eren";

  myconfig.networking = {
    nameservers = ["192.168.31.253"];
    useDHCP = false;
    interfaces = {
      "wlp4s0" = "192.168.31.102/24";
    };
  };

  shared.myconfig = {name, ...}: {
    networking.hosts."192.168.31.102" = [name];
  };
}
