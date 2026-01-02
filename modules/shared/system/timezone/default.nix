{
  lib,
  config,
  ...
}: let
  inherit (lib.mine.options) mkOpt;
  cfg = config.mine.system.timezone;
in {
  options.mine.system.timezone = {
    enable = lib.mkEnableOption "Enable time";
    location = mkOpt lib.types.str "Timezone Location";
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = "${cfg.location}";
  };
}
