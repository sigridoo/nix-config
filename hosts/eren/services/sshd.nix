{ delib, ... }:
delib.host {
  name = "eren";

  shared.myconfig = {name, ...}: {
    services = {
      sshd = {
        # TODO: Change it
        authorizedKeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAPv8aRmQPhBLDQxX7UW6o1zzg9ERhgxLE3AmT+1xX5 sigrid@eris"];
      };
    };
  };
}
