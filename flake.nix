{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.vimUtils.buildVimPlugin {
          pname = "figtree.nvim";
          version = "unstable";
          src = ./.;
          buildInputs = [ pkgs.figlet ];
          meta = {
            description = "figlet startup banner for neovim";
            homepage = "https://github.com/anuramat/figtree.nvim";
          };
        };
      }
    );
}
