{
  delib,
  lib,
  constants,
  ...
}:
delib.module {
  name = "user";

  nixos.always = let
    inherit (constants) username;
  in {
    imports = [(lib.mkAliasOptionModule ["user"] ["users" "users" username])];

    users.mutableUsers = false;

    sops.secrets."users.${username}.hashedPassword".neededForUsers = true;

    user.isNormalUser = true;
    user.extraGroups = ["wheel"];
    user.hashedPasswordFile = sops.secrets."users.${username}.hashedPassword".path;

    # users = {
    #   groups.${username} = {};
    #
    #   users.${username} = {
    #     isNormalUser = true;
    #     hashedPasswordFile = decryptSecretFile "user/hashedPassword";
    #     initPassword = "123456";
    #     extraGroups = ["wheel"];
    #   };
    # };
  };
}
