{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  tmMajorMinor = "0.1";
  tmPatch = "4";
  tmSuffix = "-abciplus";
  tmVersion = "${tmMajorMinor}.${tmPatch}${tmSuffix}";
  tmRepo = "https://github.com/heliaxdev/tendermint";
in
stdenv.mkDerivation {
  name = "tendermint";

  src = fetchurl {
    url = "${tmRepo}/releases/download/v${tmVersion}/tendermint_${tmVersion}_linux_amd64.tar.gz";
    sha256 = "sha256-AMDJTzmqxU8/hQ6HtAT7KmXeAHGPms8z+89qg6eUfqw=";
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
    cp unpacked/tendermint $out/bin
  '';
}
