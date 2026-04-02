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
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.12.3/arconia-cli-0.12.3-linux-amd64.zip";
              hash = "sha256-MjUss35IkW77kA13Z/u101skfmklnqLBwKjS67hQN/Y=";
            };
            aarch64-linux = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.12.3/arconia-cli-0.12.3-linux-aarch64.zip";
              hash = "sha256-MHM2ERHbKAXvZnd1zVhZvk9MWyfiRnPplGPq2LMGW6I=";
            };
            aarch64-darwin = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.12.3/arconia-cli-0.12.3-macos-aarch64.zip";
              hash = "sha256-ugsn0XaFD2HnraCfGzaJxQDL2gKveSKuxB3rXutvfkk=";
            };
          };
          arconia = pkgs.stdenv.mkDerivation {
            pname = "arconia";
            version = "0.12.3";
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
