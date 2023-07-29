{
  description = "blinkstick white/off scripts";
  
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (self: super: {
            python3Packages = super.python3Packages // {
              BlinkStick = pkgs.python3Packages.buildPythonPackage rec {
                pname = "blinkstick";
                version = "1.2.1"; 

                src = pkgs.fetchFromGitHub {
                  owner = "arvydas";
                  repo = "blinkstick-python";
                  rev = "8140b9fa18a9ff4f0e9df8e70c073f41cb8f1d35"; 
                  sha256 = "02qfjvbinjid1hp5chi5ms3wpvfkbphnl2rcvdwwz5f87x63pdzm"; 
                };

                propagatedBuildInputs = [ pkgs.python3Packages.pyusb ];

                doCheck = false;
                pythonImportsCheck = [ "blinkstick" ];

                meta = with pkgs.lib; {
                  description = "Python package to control BlinkStick USB devices";
                  homepage = "https://github.com/arvydas/blinkstick-python";
                  license = pkgs.lib.licenses.bsd3;
                  maintainers = with pkgs.lib.maintainers; [ np ];
                };
              };
            };
          })
        ];
      };

      blinkstick-python-env = pkgs.python3.withPackages (ps: [ pkgs.python3Packages.BlinkStick ]);

      blinkstick-scripts-allWhite = pkgs.writeShellScriptBin "blinkstick-scripts-allWhite" ''
        #!/usr/bin/env python3
        from blinkstick import blinkstick

        bstick = blinkstick.find_first()

        if bstick is not None:
            num_leds = bstick.get_led_count()

            led_data = [255, 255, 255] * num_leds  # RGB for white

            bstick.set_led_data(0, led_data)
        else:
            print("No BlinkSticks found...")
      '';

      blinkstick-scripts-allOff = pkgs.writeShellScriptBin "blinkstick-scripts-allOff" ''
        #!/usr/bin/env python3
        from blinkstick import blinkstick

        bstick = blinkstick.find_first()

        if bstick is not None:
            num_leds = bstick.get_led_count()

            led_data = [0, 0, 0] * num_leds  # RGB for black (off)

            bstick.set_led_data(0, led_data)
        else:
            print("No BlinkSticks found...")
      '';

    in {
      devShells.default = pkgs.mkShell {
        packages = [ pkgs.bashInteractive pkgs.python3 pkgs.python3Packages.BlinkStick ];
      };

      packages = { 
        blinkstick-scripts-allWhite = blinkstick-scripts-allWhite.overrideAttrs (old: { buildInputs = [ blinkstick-python-env ]; });
        blinkstick-scripts-allOff = blinkstick-scripts-allOff.overrideAttrs (old: { buildInputs = [ blinkstick-python-env ]; });
      };
    });
}
