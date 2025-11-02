{ platform }:
{ config, pkgs, lib, ... }:

let
  isDarwin = platform == "darwin";
  isLinux = platform == "nixos";
in
{
  imports = [
    # Theme system (cross-platform)
    ./theme

    # Core modules (cross-platform)
    ./core

    # Platform-specific modules
    (if isDarwin then ./darwin else ./linux)
  ];

  home.stateVersion = "24.05";
}
