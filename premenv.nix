{
  stdenv,
  ...
}:
stdenv.override (stdenvPrev: {
  name = "premenv";
  extraAttrs = {
    premium = true;
    mkDerivation =
      mkDrvArgs:
      let
        drv = stdenv.mkDerivation mkDrvArgs;
        premDrv = drv.overrideAttrs (
          finalAttrs: prevAttrs: {
            premium = true;

            # use the gold linker, obviously
            NIX_CFLAGS_LINK = toString (mkDrvArgs.NIX_CFLAGS_LINK or "") + " -fuse-ld=gold";

            # perform nixpkgs gold (tm) license checks
            prePhases = [ "goldLicenseCheck" ] ++ (prevAttrs.prePhases or [ ]);
            goldLicenseCheck = ''
              if [[ -z "$goldLicense" ]]; then
                printf "This derivation requires \033[33;1mnixpkgs gold\033[0m to build. Set 'goldLicense' to your \033[33;1mnixpkgs gold\033[0m license key and retry the build.\n"
                exit 1
              fi
            '';
          }
        );
      in
      premDrv;
  };
})
