{delib, pkgs, ...}:
delib.module {
  name = "programs.languages.rust";

  options = delib.singleEnableOption true;

  home.ifEnabled.home.packages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
  ];
}
