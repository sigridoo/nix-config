{
  delib,
  decryptHostSecretFile,
  decryptSecret,
  ...
}:
delib.host {
  name = "eren";

  rice = "base";
  type = "desktop";

  displays = [
    {
      name = "DP-1";
      refreshRate = 60;
      width = 3840;
      height = 2160;
      x = 0;
      y = 0;
    }
  ];
}
