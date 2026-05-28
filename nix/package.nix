{
  lib,

  # binary deps
  lazygit,

  # stuff that makes this work
  wrapNeovim,
  neovim-unwrapped,
  vimPlugins,

  bundleLSPs ? true,
  newyddVersion,
}:
let
  inherit (lib) optionals flatten;
  # HACK: YOLO for now
  grammars = vimPlugins.nvim-treesitter.withAllGrammars;
in
wrapNeovim {
  pname = "newydd";

  versionSuffix = newyddVersion;
  basePackage = neovim-unwrapped;

  # aliases = [
  #   "vi"
  #   "vim"
  # ];

  userConfig = ../config;

  # plugins loaded on startup
  startPlugins =
    with vimPlugins;
    [
      lz-n # lazy.nvim stuff without installer
      lzn-auto-require # ???
      nvim-lspconfig
      plenary-nvim # dep for a lot of stuff
    ]
    ++ [ grammars ]; # treesitter grammars

  # plugins loaded on demand
  optPlugins = with vimPlugins; [
    snacks-nvim
    gitsigns-nvim
    evergarden-nvim
    lualine-nvim
    neo-tree-nvim
    nui-nvim
    aerial-nvim
    mini-icons
    indent-blankline-nvim

  ];

  # binary deps
  extraPackages = flatten [
    [
      lazygit
    ]

    # lsps if you want
    (optionals bundleLSPs [

    ])
  ];
}
