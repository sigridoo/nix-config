{delib, host, ...}:
delib.module {
  name = "programs.zoxide";
  options = delib.singleEnableOption host.cliFeatured;
  myconfig.ifEnabled.persist.user.directories = [".local/share/zoxide"];
  home.ifEnabled.programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };
}
