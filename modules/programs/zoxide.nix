{delib, host, ...}:
delib.modules {
  name = "programs.zoxide";
  options = singleEnableOption host.cliFeatured;
  myconfig.ifEnabled.persist.user.directories = [".local/share/zoxide"];
  home.ifEnabled.programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };
}
