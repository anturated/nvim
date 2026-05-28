{
  wrapNeovim,
  neovim-unwrapped,
  vimPlugins,

  newyddVersion,
}:

wrapNeovim {
  pname = "newydd";

  versionSuffix = newyddVersion;
  basePackage = neovim-unwrapped;

  # aliases = [
  #   "vi"
  #   "vim"
  # ];

  userConfig = ../config;

  # all the plugins that should be stored in the neovim start directory
  # these are the plugins that are loaded when neovim starts
  startPlugins = with vimPlugins; [
    nvim-treesitter.withAllGrammars
  ];

  # these are plugins that are loaded on demand by your configuration
  optPlugins = with vimPlugins; [
  ];

  # these are any extra packages that should be available in your neovim environment
  extraPackages = [
  ];
}
