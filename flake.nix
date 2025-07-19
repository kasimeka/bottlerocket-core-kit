{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.rust-overlay = {
    url = "github:oxalica/rust-overlay";
    inputs.nixpkgs.follows = "nixpkgs-unstable";
  };
  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs-unstable {
        inherit system;
        overlays = [inputs.rust-overlay.overlays.default];
      };
      rust-toolchain = pkgs.rust-bin.stable.latest.minimal;
    in {
      devShells.default =
        (pkgs.buildFHSEnv {
          name = "hmmmm";
          targetPkgs = pkgs:
            (with pkgs; [
              glibc

              go
              gofumpt
              gopls
              gotools
              gnumake

              openssl
              # lz4
              # perl540Packages.perl

              pkg-config
              # automake
              # cmake
              gcc

              cargo-hack
            ])
            ++ (with pkgs.llvmPackages; [
              clang
              clang-tools
            ])
            ++ [
              (rust-toolchain.override
                {extensions = ["rustfmt" "rust-src" "rust-analyzer" "clippy"];})
            ];
          runScript = "bash";
        }).env;
    });
}
