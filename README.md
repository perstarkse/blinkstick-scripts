# blinkstick-scripts

A Nix flake for developing and using blinkstick scripts. This package provides an environment agnostic solution for executing BlinkStick control scripts without depending on system python packages.

## Usage

### Add directly to system or home packages

1. Import the flake in the inputs of your flake file:
    ```nix
    inputs.blinkstick-scripts.url = "github:perstarkse/blinkstick-scripts";
    ```

2. Add it to outputs:
    ```nix
    outputs = { self, nixpkgs, blinkstick-scripts, ... }: { ... };
    ```

3. Include it in your system or user packages:
    ```nix
    home.packages = [ 
      ...
      blinkstick-scripts.packages."x86_64-linux".blinkstick-scripts
    ];
    ```

### Add as an overlay

1. Import the flake in the inputs of your flake file:
    ```nix
    inputs.blinkstick-scripts.url = "github:<username>/blinkstick-scripts";
    ```

2. Include it in your overlay file:
    ```nix
    modifications = final: prev: {
      ...
      blinkstick-scripts = inputs.blinkstick-scripts.packages."x86_64-linux".blinkstick-scripts;
    };
    ```
3. Add it to packages:
    ```nix
    home.packages = [ 
      ...
      blinkstick-scripts
    ];
    ```

### Command Usage

Once installed, the `blinkstick-scripts` command can be used from the terminal with one of the following arguments: 'red', 'white', 'pink', or 'off'. This sets the color of the connected BlinkStick device.

Example:

```sh
blinkstick-scripts white
```

## Development

This section provides instructions for building and modifying the `blinkstick-scripts` package, as well as how to enter the development environment.

### Building

To build the package, use the following command:

```sh
nix build .#blinkstick-scripts
```

The resulting binary will be placed in a `result/` directory at the root of the project.

### Modifying the Python Script

The python script is written using pkgs.writeScriptBin. So edit the flake.nix and start replacing the code from line 46. 

### Entering the Development Environment

To enter the development environment, use the following command:

```sh
nix develop
```

This command opens a new shell where all the dependencies for the project are available. You can use this shell to test and debug your changes to the `blinkstick-scripts` package.
