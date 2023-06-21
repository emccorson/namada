{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  tmMajorMinor = "0.37";
  tmPatch = "2";
  tmSuffix = "";
  tmVersion = "${tmMajorMinor}.${tmPatch}${tmSuffix}";
  tmRepo = "https://github.com/cometbft/cometbft";
in
stdenv.mkDerivation {
  name = "cometbft";

  src = fetchurl {
    url = "${tmRepo}/releases/download/v${tmVersion}/cometbft_${tmVersion}_linux_amd64.tar.gz";
    sha256 = "sha256-bW06Kdx7glCNlWbv64WG1NdiiARV+9TWxRnYWAl85pc=";
  };

  unpackPhase = ''
    mkdir unpacked
    tar xvfz $src -C unpacked
  '';

  dontConfigure = true;
  dontBuild = true;

  #nativeBuildInputs = [
  #  autoPatchelfHook
  #];

  #buildInputs = [
  #  stdenv.cc.cc.lib
  #];

  installPhase = ''
    mkdir -p $out/bin
    cp unpacked/cometbft $out/bin
  '';
}
