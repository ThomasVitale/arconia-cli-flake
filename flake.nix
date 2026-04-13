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
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.14.0/arconia-cli-0.14.0-linux-amd64.zip";
              hash = "sha256-lEpuynJUGak05MVczbhi10dYgckO+owro+hpOgmiQxw=";
            };
            aarch64-linux = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.14.0/arconia-cli-0.14.0-linux-aarch64.zip";
              hash = "sha256-JfrxUJNTYPNJEtJ7KHO0ekunMo0rnEj9Cb5hmxZeAgM=";
            };
            aarch64-darwin = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.14.0/arconia-cli-0.14.0-macos-aarch64.zip";
              hash = "sha256-rGhSbHdA/bnAhDoNtAu3JWcu3pgaOivngwK6qo5UNQo=";
            };
          };
          arconia = pkgs.stdenv.mkDerivation {
            pname = "arconia";
            version = "0.14.0";
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
