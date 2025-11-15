{ platform, username, profile }:
{ config, pkgs, lib, ... }:

let
  isDarwin = platform == "darwin";
  isLinux = platform == "nixos";

  # Construct home directory path as a proper string
  homeDir = if isDarwin
    then "/Users/" + username
    else "/home/" + username;

  # User identity configuration based on profile
  userInfo = {
    name = "Kyle Briggs";
    email = {
      personal = "briggsy87@gmail.com";
      work = "kyle.briggs@prenuvo.com";
      # Primary email selected based on profile
      primary = if profile == "work"
        then "kyle.briggs@prenuvo.com"
        else "briggsy87@gmail.com";
    };
  };
in
{
  imports = [
    # Theme system (cross-platform)
    ./theme

    # Shared packages and configs (cross-platform)
    ./shared.nix

    # Core modules (cross-platform)
    ./core

    # Platform-specific modules
    (if isDarwin then ./darwin else ./linux)
  ];

  # Make profile and userInfo available to all imported modules
  _module.args = {
    inherit profile userInfo;
  };

  # Set home-manager user info
  home.username = lib.mkDefault username;
  home.homeDirectory = lib.mkDefault homeDir;

  home.stateVersion = "24.05";
}
