{ delib, host, ... }:
delib.host {
  name = "eren";
  myconfig.programs.shell.enabledShells = ["bash" "nushell"];
}
