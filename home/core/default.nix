{ ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./terminal.nix
    ./languages.nix
    ./neovim.nix
  ];

  # Enable font management
  fonts.fontconfig.enable = true;
}
