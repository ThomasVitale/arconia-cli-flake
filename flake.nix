{
  description = "Arconia CLI";
 
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
 
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
 
          arconiaFor = {
            x86_64-linux = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.12.0/arconia-cli-0.12.0-linux-amd64.zip";
              hash = "sha256-4ip7ThifgGxtnteHiehg6zjmJZpXNLgfQeGYWLmlk0E=";
            };
            aarch64-linux = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.12.0/arconia-cli-0.12.0-linux-aarch64.zip";
              hash = "sha256-6ASZEAGkg6gWWVj7MuhtZgnJkRLdCTiDhAV2ViSg0AM=";
            };
            aarch64-darwin = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.12.0/arconia-cli-0.12.0-macos-aarch64.zip";
              hash = "sha256-o1Xw3/3GWkhMowifIubqrYL/j77g5Jt5+K1QPZCU1ag=";
            };
          };
          arconia = pkgs.stdenv.mkDerivation {
            pname = "arconia";
            version = "0.12.0";
            src = pkgs.fetchurl arconiaFor.${system};
            nativeBuildInputs = [ pkgs.unzip ];
            dontStrip = true;
            installPhase = ''
              mkdir -p $out
              cp -r * $out/
            '';
          };
        in
        {
          default = arconia;
        }
      );
    };
}
