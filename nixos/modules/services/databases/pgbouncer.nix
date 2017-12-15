{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types optionalAttrs singleton mapAttrsToList concatStringsSep;
  cfg = config.services.pgbouncer;

  pgbouncerUser = "pgbouncer";
  pgbouncerGroup = "pgbouncer";

  databaseOpts = { user, ... }: {
    options = {
      host = mkOption {
        type = types.str;
        description = ''
          Hostname (or IP address) of the destination database.
        '';
        example = "127.0.0.1";
      };
      dbname = mkOption {
        type = types.str;
        description = ''
          Destination database name.
        '';
      };
      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          If user is set, all connections to the destination database will be done with the specified user, meaning that there will be only one pool for this database.
          '';
      };
      port = mkOption {
        type = types.int;
        description = ''
          Destination database port.
        '';
      };
    };
  };

in {
  options = {
    services.pgbouncer = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the PgBouncer service
        '';
      };

      user = mkOption {
        type = types.str;
        default = "pgbouncer";
        description = ''
          User account under which pgbouncer runs.  A pgbouncer account
          is created by default if none is specified.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "pgbouncer";
        description = ''
          Group under which pgbouncer runs.  A pgbouncer group is
          automatically created if it doesn't exist.
        '';
      };

      authType = mkOption {
        type = types.enum [ "hba" "cert" "md5" "plain" "trust" "any" ];
        description = ''
          How to authenticate users.
        '';
      };
      authFile = mkOption {
        type = types.path;
        description = ''
          Path to the file containing usernames and passwords.
        '';
      };
      databases = mkOption {
        type = types.loaOf (types.submodule databaseOpts);
        description = ''
          The set of available database connections to proxy.
        '';
        default = [];
        example = {
          template1 = {
            host = "127.0.0.1";
            dbname = "template1";
            user = "someuser";
            port = 5432;
          };
        };
      };

      listen = {
        port = mkOption {
          type = types.int;
          default = 6543;
          description = ''
            Which port to listen on.
          '';
        };
        addr = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = ''
            IP address to listen for a TCP connection. Addresses can be specified numerically (IPv4/IPv6) or by name.
            You may also use * meaning "listen on all addresses".
          '';
          example = "127.0.0.1";
        };
      };

      extraConfig = mkOption {
        type = types.attrs;
        description = "Extra lines for the PgBouncer configuration.";
        default = {};
        example = {
          pool_mode = "session";
          max_client_conn = 10;
          default_pool_size = 10;
        };
      };

      logDir = mkOption {
        type = types.path;
        default = "/var/log/pgbouncer";
        description = ''
          Directory for PgBouncer log files.  It is created automatically.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.pgbouncer
    ];

    users.extraUsers = mkIf (cfg.user == "pgbouncer") {
      pgbouncer = {
        name = "pgbouncer";
        group = cfg.group;
        createHome = false;
        uid = config.ids.uids.pgbouncer;
        description = "PgBouncer daemon user";
      };
    };

    users.extraGroups = mkIf (cfg.group == "pgbouncer") {
      pgbouncer = {
        gid = config.ids.gids.pgbouncer;
      };
    };

    environment = {
      etc."pgbouncer/pgbouncer.ini" = {
        text =
          let
            extraConfigLines = concatStringsSep "\n"
              (mapAttrsToList (name: value: "${name} = ${value}") cfg.extraConfig);
            databaseLines = concatStringsSep "\n"
              (mapAttrsToList
                (name: value:
                  concatStringsSep " " [
                    "${name} = "
                    "host=${value.host}"
                    "dbname=${value.dbname}"
                    (lib.optionalString (value.user != null) "user=${value.user}")
                    "port=${toString value.port}"
                  ]
                )
                cfg.databases
              );
          in ''
            [databases]
            ${databaseLines}

            [pgbouncer]
            logfile = ${cfg.logDir}/pgbouncer.log
            pidfile = /var/run/pgbouncer/pgbouncer.pid
            listen_port = ${toString cfg.listen.port}
            listen_addr = ${cfg.listen.addr}
            auth_type = ${cfg.authType}
            auth_file = ${cfg.authFile}

            ${extraConfigLines}
            '';
      };
    };
    systemd.services.pgbouncer =
      let
        runPgBouncer = flags: "${pkgs.pgbouncer}/bin/pgbouncer ${flags} /etc/pgbouncer/pgbouncer.ini";
      in {
        description = "PgBouncer Daemon";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "fs.target" "postgresql.service" ];
        path = [ pkgs.pgbouncer ];
        preStart = ''
          mkdir -m 0700 -p ${cfg.logDir}
          chown ${cfg.user}:${cfg.group} ${cfg.logDir}
          touch ${cfg.logDir}/pgbouncer.log
          chown ${cfg.user}:${cfg.group} ${cfg.logDir}/pgbouncer.log
          mkdir -p /var/run/pgbouncer
          chown ${cfg.user}:${cfg.group} /var/run/pgbouncer
        '';
        serviceConfig = {
          User = pgbouncerUser;
          ExecStart = runPgBouncer "";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          PermissionsStartOnly = true; # preStart must be run as root in order to create directories
          PIDFile = "/var/run/pgbouncer/pgbouncer.pid";
        };
      };
  };
}
