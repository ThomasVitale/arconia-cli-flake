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
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.19.2/arconia-cli-0.19.2-linux-amd64.zip";
              hash = "sha256-J7yJDhkQAHYH+mMmPDGxPBc6dk6+kZ7kYH/UEyFINNw=";
            };
            aarch64-linux = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.19.2/arconia-cli-0.19.2-linux-aarch64.zip";
              hash = "sha256-ELjqNs5Ck/kgcCTme3/uTD6n6siWRGPDicgWL/3ZtYs=";
            };
            aarch64-darwin = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.19.2/arconia-cli-0.19.2-macos-aarch64.zip";
              hash = "sha256-FCZhjTSUUiqWaQuc6v7zpxUTa7/7iaedF3zBLR8idO8=";
            };
          };
          arconia = pkgs.stdenv.mkDerivation {
            pname = "arconia";
            version = "0.19.2";
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
