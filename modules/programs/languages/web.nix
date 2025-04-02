{delib, pkgs, ...}:
delib.module {
  name = "programs.languages.web";

  options = delib.singleEnableOption true;

  home.ifEnabled.home.packages = with pkgs; [
    nodePackages.nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server
    # HTML/CSS/JSON/ESLint language servers extracted from vscode
    nodePackages.vscode-langservers-extracted
    nodePackages."@tailwindcss/language-server"
    emmet-ls
    nodePackages.prettier # common code formatter
  ];
}
