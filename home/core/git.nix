{ config, pkgs, lib, userInfo, ... }:

{
  home.packages = with pkgs; [
    git
    git-lfs
    lazygit
    # gitui - fails to build on aarch64-darwin (assembly code issue)
    delta
  ];

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user.name = userInfo.name;
      user.email = userInfo.email.primary;
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
