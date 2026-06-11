{
  outputs =
    inputs:
    let
      mkFigtree =
        pkgs:
        pkgs.vimUtils.buildVimPlugin {
          pname = "figtree.nvim";
          version = "unstable";
          src = ./.;
          postPatch = ''
            substituteInPlace lua/figtree/io.lua \
              --replace-fail "'figlet'," "'${pkgs.figlet}/bin/figlet',"
          '';
          meta = {
            description = "figlet startup banner for neovim";
            homepage = "https://github.com/anuramat/figtree.nvim";
          };
        };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      imports = [ inputs.treefmt-nix.flakeModule ];

      flake.overlays.default = final: prev: {
        vimPlugins = prev.vimPlugins // {
          figtree-nvim = mkFigtree final;
        };
      };

      perSystem =
        { pkgs, config, ... }:
        {
          packages = {
            figtree-nvim = mkFigtree pkgs;
            default = config.packages.figtree-nvim;
          };

          apps.default.program =
            let
              pkg = pkgs.wrapNeovim pkgs.neovim-unwrapped {
                configure = {
                  packages.figtree.start = [ config.packages.default ];
                  customRC = ''
                    lua require("figtree").setup()
                  '';
                };
              };
            in
            "${pkg}/bin/nvim";

          treefmt.programs = {
            stylua.enable = true;
            nixfmt.enable = true;
          };
        };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
