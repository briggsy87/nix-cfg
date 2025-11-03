{ platform, username }:
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

  # Set home-manager user info
  home.username = username;
  home.homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

  home.stateVersion = "24.05";
}
