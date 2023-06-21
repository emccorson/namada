{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
      with pkgs;
      {
        devShells.default = pkgs.mkShell.override {
          stdenv = pkgs.llvmPackages_12.stdenv;
        } {
          buildInputs = [
            openssl
            systemd
          ];
          nativeBuildInputs = [
            (callPackage ./tendermint.nix { })
            (callPackage ./cometbft.nix { })
            rustup
            protobuf
            pkg-config
            #llvmPackages_12.libclang
            #clang
            binaryen
            python3
            docker
            expect
          ];
          # See https://github.com/NixOS/nixpkgs/issues/52447
          LIBCLANG_PATH = "${llvmPackages_12.libclang.lib}/lib";
          BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${llvmPackages_12.libclang.lib}/lib/clang/${lib.getVersion clang}/include";
        };
      }
    );
}
