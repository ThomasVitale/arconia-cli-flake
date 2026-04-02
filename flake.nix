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
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.12.2/arconia-cli-0.12.2-linux-amd64.zip";
              hash = "sha256-EuC8UjGBkCtM82Pa+MQkNxuaQxuOjg0+8/QJ9Ok3D68=";
            };
            aarch64-linux = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.12.2/arconia-cli-0.12.2-linux-aarch64.zip";
              hash = "sha256-Lgnt9TEd57k/GA9rVmNw4hlN5xaXJpyYYO3r2ZX8l0Q=";
            };
            aarch64-darwin = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.12.2/arconia-cli-0.12.2-macos-aarch64.zip";
              hash = "sha256-9Ju99cuZwoGOVRbJ0Asi+2L7Z25Xskahmc1tFrAE6iQ=";
            };
          };
          arconia = pkgs.stdenv.mkDerivation {
            pname = "arconia";
            version = "0.12.2";
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
