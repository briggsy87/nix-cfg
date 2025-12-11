{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Programming languages
    nodejs_22
    python313
    terraform
    tflint

    # LSP servers (Nix-managed, no Mason needed)
    pyright
    ruff
    black
    isort
    typescript-language-server
    vscode-langservers-extracted  # eslint, html, css, json
    prettier
    terraform-ls
    bash-language-server
    yaml-language-server
    dockerfile-language-server
    lua-language-server
    stylua
    shfmt
    nixd  # Nix LSP
    nixfmt-rfc-style  # Nix formatter

    # AI assistants
    claude-code
  ];
}
