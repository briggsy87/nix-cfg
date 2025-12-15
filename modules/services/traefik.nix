# Traefik - Reverse proxy with automatic HTTPS via Let's Encrypt
# Supports AWS Route53 DNS challenge for wildcard certificates

{ config, pkgs, lib, ... }:

{
  services.traefik = {
    enable = true;

    # Static configuration
    staticConfigOptions = {
      # Enable API and dashboard
      api = {
        dashboard = true;
        insecure = true; # TODO: Secure with auth middleware
      };

      # Entry points
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";
          http.tls = {
            certResolver = "letsencrypt";
          };
        };
      };

      # Let's Encrypt certificate resolver with DNS challenge
      certificatesResolvers = {
        letsencrypt = {
          acme = {
            email = "briggsy87@gmail.com"; # Change to your email
            storage = "/var/lib/traefik/acme.json";
            dnsChallenge = {
              provider = "route53";
              delayBeforeCheck = 0;
            };
          };
        };
      };

      # Providers
      providers = {
        # File provider for static configuration
        file = {
          directory = "/etc/traefik/conf.d";
          watch = true;
        };
        # Docker provider (if needed later)
        docker = {
          endpoint = "unix:///var/run/docker.sock";
          exposedByDefault = false;
        };
      };

      # Logging
      log = {
        level = "INFO";
      };
      accessLog = {};
    };

  };

  # Set AWS environment variables from SOPS secrets
  systemd.services.traefik.serviceConfig.EnvironmentFile = pkgs.writeText "traefik-aws-env" ''
    AWS_REGION=us-east-1
  '';

  # Script to inject AWS credentials before starting Traefik
  systemd.services.traefik.script = lib.mkForce ''
    # Export AWS credentials from SOPS secrets
    export AWS_ACCESS_KEY_ID=$(cat ${config.sops.secrets.aws_access_key_id.path})
    export AWS_SECRET_ACCESS_KEY=$(cat ${config.sops.secrets.aws_secret_access_key.path})
    export AWS_REGION=us-east-1

    # Start Traefik
    exec ${pkgs.traefik}/bin/traefik
  '';

  # Create configuration directory
  systemd.tmpfiles.rules = [
    "d /etc/traefik/conf.d 0755 traefik traefik -"
    "d /var/lib/traefik 0700 traefik traefik -"
  ];

  # Example dynamic configuration for services
  environment.etc."traefik/conf.d/services.yaml".text = ''
    http:
      routers:
        # Adminer
        adminer:
          rule: "Host(`db.primeforge.org`)"
          service: adminer
          entryPoints:
            - websecure
          tls:
            certResolver: letsencrypt

        # Gitea
        gitea:
          rule: "Host(`git.primeforge.org`)"
          service: gitea
          entryPoints:
            - websecure
          tls:
            certResolver: letsencrypt

      services:
        # Adminer service
        adminer:
          loadBalancer:
            servers:
              - url: "http://127.0.0.1:8080"

        # Gitea service
        gitea:
          loadBalancer:
            servers:
              - url: "http://127.0.0.1:3000"
  '';

  # Open firewall ports
  networking.firewall.allowedTCPPorts = [ 80 443 8080 ]; # 8080 for Traefik dashboard

  # Note: AWS credentials are loaded from SOPS secrets
  # The secrets are mounted as environment variable files
}
