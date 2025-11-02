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
    userName = "Kyle Briggs";
    userEmail = "briggsy87@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # Delta - syntax-highlighted git diffs (themed by Stylix)
  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
      line-numbers = true;
    };
  };

  # Integrate delta with git
  programs.git.delta.enable = true;
}
