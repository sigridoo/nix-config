{delib, ...}:
delib.module {
  name = "programs.languages.dockerfile";

  options = delib.singleEnableOption true;

  home.ifEnabled.home.packages = with pkgs; [
    hadolint # Dockerfile linter
    nodePackages.dockerfile-language-server-nodejs
  ];
}
