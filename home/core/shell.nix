{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Shell utilities
    zoxide
    fzf
    direnv
  ];

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      nv = "nvim";
    };
    initContent = ''
      # Add local bin to PATH for user scripts
      export PATH="$HOME/.local/bin:$PATH"

      # Zoxide for smart directory jumping
      eval "$(zoxide init zsh)"

      # Starship prompt
      eval "$(starship init zsh)"

      # Default editor
      export EDITOR=nvim
      export VISUAL=nvim
    '';
  };

  # Starship prompt - themed by Stylix
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Direnv for automatic environment loading
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}
