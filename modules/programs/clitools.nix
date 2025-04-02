{delib, host, pkgs, ...}:
delib.module {
  name = "programs.clitools";

  options = delib.singleEnableOption host.cliFeatured;

  myconfig.ifEnabled = {
    persist.user.directories = [".local/share/zoxide"];
    programs.bash.shellAliases = {
      cat = "bat";
    };
  };

  home.ifEnabled = {myconfig, ...}: {
    home.packages = with pkgs; [
      # Searching tools
      fd
      (ripgrep.override {withPCRE2 = true;}) 
      ast-grep

      sad # CLI search and replace, just like sed, but with diff preview.
      yq-go # yaml processor https://github.com/mikefarah/yq
      just # a command runner like make, but simpler
      delta # A viewer for git and diff output
      hyperfine # command-line benchmarking tool
      gping # ping, but with a graph(TUI)
      doggo # DNS client for humans
      duf # Disk Usage/Free Utility - a better 'df' alternative
      du-dust # A more intuitive version of `du` in rust

      # nix related
      #
      # it provides the command `nom` works just like `nix with more details log output
      nix-output-monitor
      hydra-check # check hydra(nix's build farm) for the build status of a package
      nix-index # A small utility to index nix store paths
      nix-init # generate nix derivation from url
      # https://github.com/nix-community/nix-melt
      nix-melt # A TUI flake.lock viewer
      # https://github.com/utdemir/nix-tree
      nix-tree # A TUI to visualize the dependency graph of a nix derivation
    ];
    programs = {
      eza = {
        enable = true;
        icons = "never";
        git = true;
        enableBashIntegration = myconfig.programs.bash.enable;
        enableNushellIntegration = myconfig.programs.nushell.enable;
      };
      bat = {
        enable = true;
        config = {
          pager = "less -FR";
        };
      };
      zoxide = {
        enable = true;
        enableBashIntegration = myconfig.programs.bash.enable;
        enableNushellIntegration = myconfig.programs.nushell.enable;
      };
      lazygit = {
        enable = true;
      };
    };
  };
}
