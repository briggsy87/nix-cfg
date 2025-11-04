{ ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./terminal.nix
    ./languages.nix
    ./neovim.nix
    ./email.nix
  ];

  # Enable font management
  fonts.fontconfig.enable = true;
}
