{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.gnupg;
in {
  options.mine.home-manager.cli-tools.gnupg = {
    enable = lib.mkEnableOption "hardened GPG configuration";
    ssh = lib.mkEnableOption "GPG agent SSH support for YubiKey";
    publicKeys = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      description = "List of GPG public key files to import (e.g., for YubiKey setup)";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs;
        [
          gnupg
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          pinentry_mac
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          pinentry-curses
        ];

      programs.gpg = {
        enable = true;

        publicKeys =
          map (key: {
            source = key;
            trust = "ultimate";
          })
          cfg.publicKeys;

        # Disable CCID on Darwin to avoid repeated YubiKey insertion prompts
        scdaemonSettings = lib.mkIf pkgs.stdenv.isDarwin {
          disable-ccid = true;
        };

        # Hardening based on https://github.com/drduh/config/blob/main/gpg.conf
        settings = {
          personal-cipher-preferences = "AES256 AES192 AES";
          personal-digest-preferences = "SHA512 SHA384 SHA256";
          personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
          default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
          cert-digest-algo = "SHA512";
          s2k-digest-algo = "SHA512";
          s2k-cipher-algo = "AES256";
          charset = "utf-8";
          no-comments = true;
          no-emit-version = true;
          no-greeting = true;
          keyid-format = "0xlong";
          list-options = "show-uid-validity";
          verify-options = "show-uid-validity";
          with-fingerprint = true;
          require-cross-certification = true;
          require-secmem = true;
          no-symkey-cache = true;
          armor = true;
          use-agent = true;
          throw-keyids = true;
        };
      };

      services.gpg-agent = lib.mkIf cfg.ssh {
        enable = true;
        enableSshSupport = true;
        enableZshIntegration = true;
        pinentry.package =
          if pkgs.stdenv.isDarwin
          then pkgs.pinentry_mac
          else pkgs.pinentry-curses;
      };
    };
  };
}
