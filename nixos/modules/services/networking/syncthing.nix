{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.syncthing;
  defaultUser = "syncthing";
in {
  ###### interface
  options = {
    services.syncthing = {
      enable = mkEnableOption ''
        A self-hosted, open-source alternative to Dropbox and Bittorrent Sync. An initial interface will be
        available on <link xlink:href="http://127.0.0.1:8384/"/>.

        When enabled, Syncthing is automatically run as a system-wide service. To run one or more per-user instances instead, turn this off and set <option>services.syncthing.install</option> instead. Then run <code>systemctl --user start syncthing</code> in order to start a per-user instance.
      '';

      systemService = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Auto launch Syncthing as a system service. This option is obsolete; to run Syncthing as a user service, please see <option>services.syncthing.install</option>."
      };

      user = mkOption {
        type = types.string;
        default = defaultUser;
        description = ''
          Syncthing will be run under this user (user will be created if it doesn't exist.
          This can be your user name).
        '';
      };

      group = mkOption {
        type = types.string;
        default = "nogroup";
        description = ''
          Syncthing will be run under this group (group will not be created if it doesn't exist.
          This can be your user name).
        '';
      };

      all_proxy = mkOption {
        type = types.nullOr types.string;
        default = null;
        example = "socks5://address.com:1234";
        description = ''
          Overwrites all_proxy environment variable for the syncthing process to
          the given value. This is normaly used to let relay client connect
          through SOCKS5 proxy server.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/syncthing";
        description = ''
          Path where the settings and keys will exist.
        '';
      };

      openDefaultPorts = mkOption {
        type = types.bool;
        default = false;
        example = literalExample "true";
        description = ''
          Open the default ports in the firewall:
            - TCP 22000 for transfers
            - UDP 21027 for discovery
          If multiple users are running syncthing on this machine, you will need to manually open a set of ports for each instance and leave this disabled.
          Alternatively, if are running only a single instance on this machine using the default ports, enable this.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.syncthing;
        defaultText = "pkgs.syncthing";
        example = literalExample "pkgs.syncthing";
        description = ''
          Syncthing package to use.
        '';
      };
    };
  };

  imports = [
    (mkRemovedOptionModule ["services" "syncthing" "useInotify"] ''
      This option was removed because syncthing now has the inotify functionality included under the name "fswatcher".
      It can be enabled on a per-folder basis through the webinterface.
    '')
  ];

  ###### implementation

  config = mkIf (cfg.enable || cfg.install) {

    networking.firewall = mkIf cfg.openDefaultPorts {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [ 21027 ];
    };

    systemd.packages = [ pkgs.syncthing ];

    users = mkIf (cfg.user == defaultUser) {
      users."${defaultUser}" =
        { group = cfg.group;
          home  = cfg.dataDir;
          createHome = true;
          uid = config.ids.uids.syncthing;
          description = "Syncthing daemon user";
        };

      groups."${defaultUser}".gid =
        config.ids.gids.syncthing;
    };

    systemd.user.services = {
      syncthing = mkIf cfg.enable {
        description = "Syncthing service";
        after = [ "network.target" ];
        environment = {
          STNORESTART = "yes";
          STNOUPGRADE = "yes";
          inherit (cfg) all_proxy;
        } // config.networking.proxy.envVars;
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Restart = "on-failure";
          SuccessExitStatus = "2 3 4";
          RestartForceExitStatus="3 4";
          User = cfg.user;
          Group = cfg.group;
          PermissionsStartOnly = true;
          ExecStart = "${cfg.package}/bin/syncthing -no-browser -home=${cfg.dataDir}";
        };
      };

      syncthing-resume = {
        wantedBy = [ "suspend.target" ];
      };
    };
  };

  imports = [
    (mkRemovedOptionModule ["services" "syncthing" "systemService"] ''
      This option was replaced by services.syncthing.install.
    '')
  ];
}
