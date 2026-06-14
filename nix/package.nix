{
  lib,

  # binary deps
  fd,
  ripgrep,
  lazygit,

  # LSPs and other stuff
  nil,
  statix,
  deadnix,
  nixfmt,
  shfmt,
  shellcheck,
  bash-language-server,
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
  versionSuffix,
}:
let
  inherit (lib) optionals flatten;

  grammars = vimPlugins.nvim-treesitter.withPlugins (
    p: with p; [
      # keep-sorted start
      bash
      c
      c_sharp
      comment
      cpp
      css
      csv
      diff
      dockerfile
      git_rebase
      gitattributes
      gitcommit
      gitignore
      go
      html
      javascript
      jsdoc
      json
      just
      lua
      make
      markdown
      markdown_inline
      nix
      python
      qmldir
      qmljs
      toml
      tsx
      typescript
      yaml
      # keep-sorted end
    ]
  );
in
wrapNeovim {
  pname = "newydd";

  inherit versionSuffix;
  basePackage = neovim-unwrapped;

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
    # keep-sorted start
    SchemaStore-nvim
    blink-cmp
    evergarden-nvim
    fidget-nvim
    friendly-snippets
    cloak-nvim
    conform-nvim
    gitsigns-nvim
    heirline-nvim
    indent-blankline-nvim
    lualine-nvim
    mini-icons
    neo-tree-nvim
    nightfox-nvim
    nui-nvim
    nvim-autopairs
    nvim-colorizer-lua
    nvim-lint
    nvim-navic
    nvim-surround
    nvim-ts-autotag
    nvim_context_vt
    resession-nvim
    roslyn-nvim
    snacks-nvim
    todo-comments-nvim
    vim-sleuth
    vim-wakatime
    which-key-nvim
    # keep-sorted end
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
      taplo # toml
      yaml-language-server # yaml
      lua-language-server
      stylua
    ])
  ];
}
