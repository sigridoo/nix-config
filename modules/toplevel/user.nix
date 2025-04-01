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

    user.isNormalUser = true;
    user.initPassword = "123456";
    user.extraGroups = ["wheel"];

    # users = {
    #   groups.${username} = {};
    #
    #   users.${username} = {
    #     isNormalUser = true;
    #     # hashedPasswordFile = decryptSecretFile "user/hashedPassword";
    #     initPassword = "123456";
    #     extraGroups = ["wheel"];
    #   };
    # };
  };
}
