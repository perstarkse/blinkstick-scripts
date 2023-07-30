# blinkstick-scripts

This is a Nix flake for developing and using scripts for the BlinkStick line of USB-controlled LEDs. The main goal is to create an execution environment that is independent of the system's Python packages, ensuring that the scripts work the same way regardless of the host environment.

The flake provides a Python script that can set the color of the BlinkStick to red, white, pink, or turn it off.

## Usage

1. Import the flake in your configuration file:

    ```nix
    inputs.blinkstick-scripts.url = "github:<perstarkse>/blinkstick-scripts";
    ```

2. Add the flake to the `outputs` function:

    ```nix
    outputs = { self, nixpkgs, blinkstick-scripts, ... }: { ... };
    ```

3. Add the flake package to your desired packages:

    ```nix
    home.packages = with pkgs; [ 
        ...
        blinkstick-scripts.packages."x86_64-linux".blinkstick-scripts
    ];
    ```

    Please replace `"x86_64-linux"` with your system architecture if different.

Once you've done this, the blinkstick-scripts should be available in your user environment.

