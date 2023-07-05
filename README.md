# nix-windows-fonts

This repository contains Nix package definitions for Windows 10/11's bundled fonts, currently based on Windows 22H2.

The packages don't need to download the entire Windows install ISO because they directly mount the ISO over HTTP.

## Installation

The packages are available for Linux and macOS, x86_64 and aarch64. Only x86_64-linux was tested, the others may not work.

### Flakes

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    windows-fonts.url = "git+https://git.lunaa.ch/luna/nix-windows-fonts";
    windows-fonts.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, windows-fonts, ... }: {
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          fonts.fonts = [
            windows-fonts.packages.x86_64-linux.win11Fonts
          ];
        }
      ];
    };
  };
}
```

### Legacy

```nix
# configuration.nix
let
  windows-fonts = import (builtins.fetchTarball "https://git.lunaa.ch/luna/nix-windows-fonts/archive/main.tar.gz");
in
{
  fonts.fonts = [
    windows.fonts.win11Fonts;
  ]
}
```

## License

This project (the files in this repository) is released into the public domain via the Unlicense.

The font files are Microsoft's property and their EULA prohibits usage outside Windows.