{
  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        figtree = pkgs.vimUtils.buildVimPlugin {
          pname = "figtree.nvim";
          version = "unstable";
          src = ./.;
          buildInputs = [ pkgs.figlet ];
          meta = {
            description = "figlet startup banner for neovim";
            homepage = "https://github.com/anuramat/figtree.nvim";
          };
        };
        neovim =
          let
            pkg = pkgs.wrapNeovim pkgs.neovim-unwrapped {
              configure = {
                # https://nixos.wiki/wiki/Vim#Custom_setup_without_using_Home_Manager
                packages.myPlugins = {
                  start = [
                    figtree
                  ];
                };
                customRC = ''
                  lua require("figtree").setup()
                '';
              };
            };
          in
          {
            type = "app";
            program = "${pkg}/bin/nvim";
          };
      in
      {
        packages = {
          inherit figtree;
          default = figtree;
        };
        apps = {
          inherit neovim;
          default = neovim;
        };
      }
    );

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
}
