{
  description = "Arconia CLI";
 
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
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
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.2.4/arconia-cli-0.2.4-linux-amd64.zip";
              sha256 = "17528d087aee012dea7adf28c3757c1ac46d15b2d3ec7faa79cb4b10e39e7c8a";
            };
            aarch64-linux = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.2.4/arconia-cli-0.2.4-linux-amd64.zip";
              sha256 = "17528d087aee012dea7adf28c3757c1ac46d15b2d3ec7faa79cb4b10e39e7c8a";
            };
            x86_64-darwin = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.2.4/arconia-cli-0.2.4-macos-amd64.zip";
              sha256 = "54adacc8d398c8af74b8592ca94d8eaba8ec272016851b500c601478f18cb726";
            };
            aarch64-darwin = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.2.4/arconia-cli-0.2.4-macos-aarch64.zip";
              sha256 = "6a049d0d577e65d942aec5c070cae059c994d2ba4d7547ba7281bf169bc11c10";
            };
          };
          arconia = pkgs.stdenv.mkDerivation {
            pname = "arconia";
            version = "0.2.4";
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
