{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {nixpkgs, ...}: let
    inherit (nixpkgs) lib;
    genSystems = lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    nixpkgsFor = system: import nixpkgs {inherit system;};

    packages = pkgs: let
      buildFonts = pkgs.callPackage (import ./windows-fonts.nix);
      # these URLs can be found at:
      # https://www.microsoft.com/en-us/evalcenter/download-windows-10-enterprise
      # https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise
      buildWin10Fonts = buildFonts {
        isoUrl = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso";
        windowsVersion = "10-22H2";
        outputHash = "sha256-tn4FKgKLtQRkIkNLV5/A0AsdUyeUEcnsIf5cJ7vsDHg=";
      };
      buildWin11Fonts = buildFonts {
        isoUrl = "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66751/22621.525.220925-0207.ni_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso";
        windowsVersion = "11-22H2";
        outputHash = "sha256-uapC6FT5qTHiOWrXGfNCLfuwGjOiKkUaeSsCd7b2rjc=";
      };
    in {
      win10Fonts = pkgs.vmTools.runInLinuxVM buildWin10Fonts;
      win11Fonts = pkgs.vmTools.runInLinuxVM buildWin11Fonts;
    };
  in {
    packages = genSystems (system: let pkgs = nixpkgsFor system; in packages pkgs);
    formatter = genSystems (system: let pkgs = nixpkgsFor system; in pkgs.alejandra);
  };
}
