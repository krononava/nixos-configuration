{ config, lib, pkgs, ... }:

let
  tetrd-custom = pkgs.tetrd.overrideAttrs (previousAttrs: {
    src = builtins.fetchurl {
      url = "https://download.tetrd.app/files/tetrd.linux_amd64.pkg.tar.xz";
      sha256 = "2sn9IJzusPjOhYuWg+53hlN2EP1kdCYsu+DbcsZjc0w=";
    };
  });
in
{
  disabledModules = [ "services/networking/tetrd.nix" ];

  options.services.tetrd-custom.enable = lib.mkEnableOption (lib.mdDoc "tetrd");

  config = lib.mkIf config.services.tetrd-custom.enable {
    environment = {
      systemPackages = [ tetrd-custom ];
      etc."resolv.conf".source = "/etc/tetrd/resolv.conf";
    };

    systemd = {
      tmpfiles.rules = [ "f /etc/tetrd/resolv.conf - - -" ];

      services.tetrd = {
        description = tetrd-custom.meta.description;
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "${tetrd-custom}/opt/Tetrd/bin/tetrd";
          Restart = "always";
          RuntimeDirectory = "tetrd";
          RootDirectory = "/run/tetrd";
          DynamicUser = true;
          UMask = "006";
          DeviceAllow = "usb_device";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateMounts = true;
          PrivateNetwork = lib.mkDefault false;
          PrivateTmp = true;
          PrivateUsers = lib.mkDefault false;
          ProtectClock = lib.mkDefault false;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RemoveIPC = true;
          RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";

          SystemCallFilter = [
            "@system-service"
            "~@aio"
            "~@chown"
            "~@clock"
            "~@cpu-emulation"
            "~@debug"
            "~@keyring"
            "~@memlock"
            "~@module"
            "~@mount"
            "~@obsolete"
            "~@pkey"
            "~@raw-io"
            "~@reboot"
            "~@swap"
            "~@sync"
          ];

          BindReadOnlyPaths = [
            builtins.storeDir
            "/etc/ssl"
            "/etc/static/ssl"
            "${pkgs.nettools}/bin/route:/usr/bin/route"
            "${pkgs.nettools}/bin/ifconfig:/usr/bin/ifconfig"
          ];

          BindPaths = [
            "/etc/tetrd/resolv.conf:/etc/resolv.conf"
            "/run"
            "/var/log"
          ];

          CapabilityBoundingSet = [
            "CAP_DAC_OVERRIDE"
            "CAP_NET_ADMIN"
          ];

          AmbientCapabilities = [
            "CAP_DAC_OVERRIDE"
            "CAP_NET_ADMIN"
          ];
        };
      };
    };
  };
}
