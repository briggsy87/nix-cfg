# Disko disk configuration for infra-01
# This file defines the disk partitioning scheme for nixos-anywhere
# Based on official nixos-anywhere-examples

{ lib, ... }:
{
  disko.devices = {
    disk = {
      # Main OS disk (20G from Terraform - /dev/sda)
      main = {
        device = lib.mkDefault "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              name = "root";
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [ "defaults" ];
              };
            };
          };
        };
      };

      # Data disk (50G from Terraform - /dev/sdb)
      data = {
        device = lib.mkDefault "/dev/sdb";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            primary = {
              name = "data";
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/data";
                mountOptions = [ "defaults" ];
              };
            };
          };
        };
      };
    };
  };
}
