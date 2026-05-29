# Newydd

the nvim config or something.
TODO: come up with a good description

## Usage

### Run without installing
```bash
nix run github:anturated/nvim
```

### Install
If for whatever reason you want this installed,
add this to your flake's inputs and outputs
```nix
{
  inputs = {
    # this
    newydd = {
      url = "github:anturated/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    # this
    { newydd, ... }:
    {
      modules = [
        # and this
        newydd.packages."<your_arch>".default
      ];
    }
}
```

or if you're like that:

```bash
nix profile add github:anturated/nvim
```

## TODO
- [x] autopairs
- [x] omnisharp
- [ ] better banner (or at least color it)
- [ ] kanagawa paper
- [x] breadcrumbs
- [x] notif picker or bind
- [ ] look through todos

## Thank/Credit
[isabelroses](https://github.com/isabelroses/nvim) - inspo for packaging this and some snippets
