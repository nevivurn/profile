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
          install -Dm644 profile-500.png $out/profile-500.png
          install -Dm644 profile-2500.png $out/profile-2500.png
          runHook postInstall
        '';
      };
    };
}
