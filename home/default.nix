{ platform }:
{ config, pkgs, lib, ... }:

let
  isDarwin = platform == "darwin";
  isLinux = platform == "nixos";
in
{
  imports = [
    ./shared.nix
    (if isDarwin then ./darwin.nix else ./linux.nix)
  ];

  home.stateVersion = "24.05";
}
