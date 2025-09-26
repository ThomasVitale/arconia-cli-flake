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
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.6.0/arconia-cli-0.6.0-linux-amd64.zip";
              hash = "d6Hp2o38aYkoq9PHZXe6chIf2xbREdHZUiERwwmlzK4=";
            };
            aarch64-linux = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.6.0/arconia-cli-0.6.0-linux-aarch64.zip";
              hash = "vRWhbAhp/XRrbda0PQrQJQxI5yrs8LaN5bWhOhm0Uo4=";
            };
            x86_64-darwin = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.6.0/arconia-cli-0.6.0-macos-amd64.zip";
              hash = "WIlOrCMQbdjdxfVjLzw505/mXgHf1ntBDG6JzoVxyug=";
            };
            aarch64-darwin = {
              url = "https://github.com/arconia-io/arconia-cli/releases/download/v0.6.0/arconia-cli-0.6.0-macos-aarch64.zip";
              hash = "sha256-9Q1BE/ls7b+KgtLhfpvwcWPMfOKjpRHn5VCUv98AE0s=";
            };
          };
          arconia = pkgs.stdenv.mkDerivation {
            pname = "arconia";
            version = "0.6.0";
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
