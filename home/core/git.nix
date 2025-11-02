{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    git
    git-lfs
    lazygit
    gitui
    delta
  ];

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user.name = "Kyle Briggs";
      user.email = "briggsy87@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # Delta - syntax-highlighted git diffs (themed by Stylix)
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
      line-numbers = true;
    };
  };
}
