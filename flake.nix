{
  description = "script for interacting with my blinkstick flex";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (self: super: {
            python3Packages =
              super.python3Packages
              // {
                BlinkStick = pkgs.python3Packages.buildPythonPackage rec {
                  pname = "blinkstick";
                  version = "1.2.0";

                  src = pkgs.fetchFromGitHub {
                    owner = "arvydas";
                    repo = "blinkstick-python";
                    rev = "8140b9fa18a9ff4f0e9df8e70c073f41cb8f1d35";
                    sha256 = "02qfjvbinjid1hp5chi5ms3wpvfkbphnl2rcvdwwz5f87x63pdzm";
                  };

                  propagatedBuildInputs = [pkgs.python3Packages.pyusb];

                  doCheck = false;
                  pythonImportsCheck = ["blinkstick"];

                  meta = with pkgs.lib; {
                    description = "Python package to control BlinkStick USB devices";
                    homepage = "https://github.com/arvydas/blinkstick-python";
                    license = pkgs.lib.licenses.bsd3;
                    maintainers = with pkgs.lib.maintainers; [np];
                  };
                };
              };
          })
        ];
      };

      blinkstick-python-env = pkgs.python3.withPackages (ps: [pkgs.python3Packages.BlinkStick]);

      blinkstick-scripts = pkgs.writeScriptBin "blinkstick-scripts" ''
        #!${blinkstick-python-env.interpreter}
        from blinkstick import blinkstick
        import sys

        bstick = blinkstick.find_first()

        if bstick is not None:
            num_leds = bstick.get_led_count()
            print(num_leds)

            if sys.argv[1] == 'white':
                led_data = [255, 255, 255] * num_leds
            elif sys.argv[1] == 'off':
                led_data = [0, 0, 0] * num_leds
            elif sys.argv[1] == 'red':
                led_data = [0, 255, 0] * num_leds
            elif sys.argv[1] == 'pink':
                led_data = [105, 255, 180] * num_leds
            else:
                print("Invalid argument")
                sys.exit(1)

            bstick.set_led_data(0, led_data)
        else:
            print("No BlinkSticks found...")
      '';

      scriptEnv = pkgs.python3.withPackages (ps: [pkgs.python3Packages.BlinkStick]);
    in {
      devShells.default = pkgs.mkShell {
        packages = [pkgs.bashInteractive pkgs.python3 pkgs.python3Packages.BlinkStick];
      };

      packages = {
        blinkstick-scripts = blinkstick-scripts.overrideAttrs (old: {path = [scriptEnv];});
      };
    });
}
