{delib, ...}:
delib.host {
  name = "eren";

  myconfig.persist = {
    enable = true;
    persistPath = "/.persist";
  };
}
