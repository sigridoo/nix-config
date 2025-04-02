{ delib, host, ... }:
delib.host {
  name = "eren";
  myconfig.programs.bash = {
    enable = true;
    shellAliases = {
      cat = "bat";
    }
  };
}
