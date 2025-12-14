# Adminer - Database management web UI
# Accessible at http://<server-ip>:8080
# Manual setup since NixOS doesn't have a built-in adminer service

{ config, pkgs, ... }:

{
  # Install adminer package
  environment.systemPackages = [ pkgs.adminer ];

  # Create systemd service for adminer with PHP's built-in web server
  systemd.services.adminer = {
    description = "Adminer Database Management";
    after = [ "network.target" "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = "adminer";
      Group = "adminer";
      ExecStart = "${pkgs.php}/bin/php -S 0.0.0.0:8080 -t ${pkgs.adminer}/adminer";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

  # Create adminer user
  users.users.adminer = {
    isSystemUser = true;
    group = "adminer";
  };

  users.groups.adminer = {};

  # Open firewall port for Adminer
  networking.firewall.allowedTCPPorts = [ 8080 ];
}
