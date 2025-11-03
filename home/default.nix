{ platform, username }:
{ config, pkgs, lib, ... }:

let
  isDarwin = platform == "darwin";
  isLinux = platform == "nixos";

  # Construct home directory path as a proper string
  homeDir = if isDarwin
    then "/Users/" + username
    else "/home/" + username;
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
  home.username = lib.mkDefault username;
  home.homeDirectory = lib.mkDefault homeDir;

  home.stateVersion = "24.05";
}
