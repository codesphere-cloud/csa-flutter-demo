{
description = "Flutter 3.13.x";
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  flake-utils.url = "github:numtide/flake-utils";
};
outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          android_sdk.accept_license = true;
          allowUnfree = true;
        };
      };
      androidComposition = pkgs.androidenv.composeAndroidPackages {
	    buildToolsVersions = [ "35.0.0" ]; 
        platformVersions = [ "36" ];
        abiVersions = [ "x86_64" ];
		includeSystemImages = true;      
        systemImageTypes = [ "google_apis" ];
        includeEmulator = true;   
		includeNDK = true;
        ndkVersions = [ "27.0.12077973" ];
		cmakeVersions = [ "3.22.1" ];
      };
      androidSdk = androidComposition.androidsdk;
    in
    {
      devShell =
        with pkgs; mkShell rec {
		  NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE = "1";
          ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
          buildInputs = [
            flutter
			pkg-config
            androidSdk # The customized SDK that we've made above
			androidComposition.emulator # The emulator component
            jdk17
          ];
        };
    });
}