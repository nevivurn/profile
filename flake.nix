{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      defaultPackage.${system} = pkgs.stdenvNoCC.mkDerivation {
        name = "nevi-profile";
        nativeBuildInputs = with pkgs; [ inkscape bc fira-code ];
        src = builtins.path { path = ./.; name = "profile"; };

        installPhase = ''
          runHook preInstall
          mkdir $out
          install -Dm644 *.png $out/
          runHook postInstall
        '';
      };
    };
}
