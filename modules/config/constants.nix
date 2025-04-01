{delib, ...}:
delib.module {
  name = "constants";

  options.constants = with delib; {
    username = readOnly (strOption "sigrid");
    userfullname = readOnly (strOption "Sigrid Kitto");
    useremail = readOnly (strOption "booocchi@proton.me");
    gitemail = readOnly (strOption "205299055+sigridoo@users.noreply.github.com");
  };

  myconfig.always = {cfg, ...}: {
    args.shared.constants = cfg;
  };
}
