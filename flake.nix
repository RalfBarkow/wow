{
  description = "WOW 2025 position paper – DITA-OT publishing shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        dita = pkgs.dita-ot;
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            dita
            pkgs.jdk
            pkgs.unzip
            pkgs.git
          ];

          shellHook = ''
            if [ ! -d ".dita-ot" ]; then
              echo "[dita-ot] Creating local writable toolkit in .dita-ot"
              cp -r ${dita}/share/dita-ot .dita-ot
              chmod -R u+w .dita-ot
            fi

            export DITA_OT_DIR="$PWD/.dita-ot"
            export PATH="$DITA_OT_DIR/bin:$PATH"

            echo "[dita-ot] Using DITA-OT from: $DITA_OT_DIR"
            echo "[dita-ot] Try:  dita --version"
          '';
        };
      });
}
