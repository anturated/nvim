{
  lib,

  # binary deps
  fd,
  ripgrep,
  lazygit,

  # LSPs and other stuff
  marksman,
  tinymist,
  nil,
  statix,
  deadnix,
  nixfmt,
  shfmt,
  shellcheck,
  bash-language-server,
  proselint,
  taplo,
  yaml-language-server,
  vscode-langservers-extracted,
  lua-language-server,
  stylua,

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
    nvim-navic
    mini-icons
    indent-blankline-nvim
    heirline-nvim
    which-key-nvim
    nvim_context_vt # TODO: check out nvim-treesitter-context
    fidget-nvim
    todo-comments-nvim
    nvim-colorizer-lua
    blink-cmp
    formatter-nvim
    SchemaStore-nvim
    nvim-lint
    resession-nvim
  ];

  # binary deps
  extraPackages = flatten [
    [
      # snacks deps
      fd
      ripgrep
      lazygit
    ]

    # lsps if you want
    # these should allow editing configs, the rest you put in shell.nix
    # there still should be configs for a lot of them in servers.lua
    (optionals bundleLSPs [
      # json and by conincidence web stuff
      vscode-langservers-extracted

      # md
      marksman
      tinymist

      # nix
      nil
      statix
      deadnix
      nixfmt

      # shell
      shfmt
      shellcheck
      bash-language-server

      # misc
      proselint
      taplo # toml
      yaml-language-server # yaml
      lua-language-server
      stylua
    ])
  ];
}
