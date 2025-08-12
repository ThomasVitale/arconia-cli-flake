{
  description = "Arconia CLI";
 
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
 
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
 
          arconiaFor = {
            x86_64-linux = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.5.2/arconia-cli-0.5.2-linux-amd64.zip";
              hash = "sha256-XUY5R29P6+RS0MLU/owxKM2LKhbupIaHXOUiwPm5PM4=";
            };
            aarch64-linux = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.5.2/arconia-cli-0.5.2-linux-aarch64.zip";
              hash = "sha256-AZT/g4UxOhk1+n3RYaHps2HgixsNcoxSnoHLZ9FTyzY=";
            };
            x86_64-darwin = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.5.2/arconia-cli-0.5.2-macos-amd64.zip";
              hash = "sha256-EcxsWlkLvSrdQC0uOhUgeOqjuKQtD08YygOJfcYxoag=";
            };
            aarch64-darwin = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.5.2/arconia-cli-0.5.2-macos-aarch64.zip";
              hash = "sha256-h/r8FJvS0EjBucEI8j72HrxhHpeftz3JL/WkNPXKCLU=";
            };
          };
          arconia = pkgs.stdenv.mkDerivation {
            pname = "arconia";
            version = "0.5.2";
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
