{
  delib,
  lib,
  constants,
  config,
  ...
}:
delib.module {
  name = "user";

  nixos.always = let
    inherit (constants) username;
  in {
    imports = [(lib.mkAliasOptionModule ["user"] ["users" "users" username])];

    users.mutableUsers = false;

    user.isNormalUser = true;
    user.extraGroups = ["wheel"];
    # user.password = "123456";
    user.hashedPasswordFile = config.sops.secrets."users/${username}/hashedPassword".path;
    fileSystems."/".neededForBoot = true;

    sops.secrets."users/${username}/hashedPassword" = {
      neededForUsers = true;
      mode = "0400";
      owner = username;
    };
  };
}
