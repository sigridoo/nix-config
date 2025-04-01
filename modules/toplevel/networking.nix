{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "networking";

  options.networking = with delib; let
    ipv4CidrType = lib.types.addCheck 
    (lib.types.strMatching "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/([0-9]|[1-2][0-9]|3[0-2])$")
    (s: 
      let
        parts = lib.splitString "/" s;
        ip = lib.head parts;
        prefix = lib.toInt (lib.elemAt parts 1);
        octets = lib.splitString "." ip;
        isOctetValid = o: lib.toInt o >= 0 && lib.toInt o <= 255;
      in 
        lib.length parts == 2 && 
        lib.length octets == 4 && 
        lib.all isOctetValid octets &&
        prefix >= 0 && prefix <= 32
    );
  in {
    nameservers = listOfOption str ["192.168.31.253"];
    hosts = attrsOfOption (listOf str) {};
    useDHCP = boolOption true;
    interfaces = attrsOfOption ipv4CidrType {};
  };

  nixos.always = {cfg, ...}: {
    networking = {
      hostName = host.name;

      firewall.enable = true;
      networkmanager.enable = true;

      dhcpcd.extraConfig = "nohook resolv.conf";
      networkmanager.dns = "none";
      interfaces = lib.mapAttrs (ip: cidr:
        let
          parts = lib.splitString "/" cidr;
          ip = lib.head parts;
          prefix = lib.toInt (lib.elemAt parts 1);
        in {
          ${ip} = {
            useDHCP = false;
            ipv4.addresses = [{
              address = ip;
              prefixLength = prefix;
            }];
          };
        }
      ) cfg.interfaces;

      inherit (cfg) useDHCP hosts nameservers;
    };

    user.extraGroups = ["networkmanager"];
  };
}
