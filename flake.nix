{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { nixpkgs, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          lib,
          ...
        }:
        {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              nixfmt-rfc-style
              nixd
              postgresql
              redis
              nodejs
              pnpm_9
              procps
              imlib2
              jq
              moreutils
              cacert
              bundix
              libyaml # Added for psych gem
              openssl # Added for openssl gem
              openssl.dev # Added for headers
              pkg-config # Added to help find libraries
              zstd
              ruby_3_3
              go-task # Alternative to make
              foreman # Or use this if forego isn't available

              # Additional dependencies for Ruby native extensions
              gnumake
              gcc
              readline
              readline.dev
              zlib
              zlib.dev
              libffi
              libffi.dev
              gdbm # For Ruby stdlib dbm and gdbm
              gdbm.dev
            ];
            shellHook = ''
              export RAILS_ENV=development
              export PATH="$PWD/bin:$PATH"
              export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.readline.dev}/lib/pkgconfig:${pkgs.zlib.dev}/lib/pkgconfig:${pkgs.libffi.dev}/lib/pkgconfig"

              # Set library paths for better gem compilation
              export LDFLAGS="-L${pkgs.lib.getLib pkgs.libffi}/lib -L${pkgs.lib.getLib pkgs.readline}/lib -L${pkgs.lib.getLib pkgs.gdbm}/lib -L${pkgs.lib.getLib pkgs.zlib}/lib"
              export CPPFLAGS="-I${pkgs.lib.getDev pkgs.libffi}/include -I${pkgs.lib.getDev pkgs.readline}/include -I${pkgs.lib.getDev pkgs.gdbm}/include -I${pkgs.lib.getDev pkgs.zlib}/include"

              # Force ExecJS to use Node.js instead of Bun.sh
              export EXECJS_RUNTIME="Node"
              export NODE_PATH="${pkgs.nodejs}/lib/node_modules"

              export WEBSOCKET_SERVER_LOG_TO_STDOUT=1
              export BACKGROUND_SERVICES_LOG_TO_STDOUT=1
            '';
          };
        };
    };
}
