# Example secrets.nix structure
# Copy this to secrets.nix and fill in your values
rec {
  users = {
    me = {
      username = "your-username";
      name = "Your Name";
      email = "you@example.com";
    };
    ai71 = {
      username = "work-username";
      name = "Your Name";
      email = "work@example.com";
    };
  };
  signingKey = {
    me = "YOUR_GPG_KEY_ID";
    ai71 = "WORK_GPG_KEY_ID";
  };
  gpgPublicKey = {
    me = {
      url = "https://github.com/you.gpg";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
    ai71 = {
      url = "https://gitlab.com/you.gpg";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  };
  aliases = {
    me = {};
    ai71 = {
      username = {"${users.ai71.username}" = "alias";};
      hostname = {"Workname-MacBook-Pro" = "ai71mac";};
    };
  };
  wsl.yubikey.busid = ["1-1"];
  hosts.fiddlebender = {
    hostname = "0.0.0.0";
    user = users.me.username;
  };
  timeZone = "UTC";
}
