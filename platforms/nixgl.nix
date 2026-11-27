{ pkgs, nixgl, driver }:

let
  # nixGL passes `kernel = null` to nvidia-x11, an arg nixpkgs-26.05 removed, so
  # strip that dead line and build nixGL from the patched source
  nixglPackages =
    let
      src = pkgs.runCommand "nixgl-patched" { } ''
        cp -r ${nixgl} $out
        chmod -R +w $out
        substituteInPlace $out/nixGL.nix --replace-fail "kernel = null;" ""
      '';
    in pkgs.callPackage "${src}/nixGL.nix" { };

  # nixGL's own auto-detection can't parse new open-kernel driver strings, so
  # detect the version ourselves.
  nvidiaVersion =
    let
      verFile = pkgs.runCommand "nvidia-version" {
        time = builtins.currentTime;
        preferLocalBuild = true;
        allowSubstitutes = false;
      } "grep -oE '[0-9]+\\.[0-9]+(\\.[0-9]+)?' /proc/driver/nvidia/version | head -1 > $out";
    in pkgs.lib.trim (builtins.readFile verFile);

  # Wrap kitty with nixGL to solve the OpenGL problem on non-NixOS distros
  nixGLKittyModule = nixglPkg: nixglBin: ({ pkgs, ... }: {
    programs.kitty.package = pkgs.symlinkJoin {
      name = "kitty";
      paths = [
        (pkgs.writeShellScriptBin "kitty" ''
          ${pkgs.lib.optionalString (driver == "nvidia") ''
            if [ -n "''${WAYLAND_DISPLAY:-}" ]; then
              export __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS=${pkgs.egl-wayland}/share/egl/egl_external_platform.d
            fi
          ''}
          exec ${nixglPkg}/bin/${nixglBin} ${pkgs.kitty}/bin/kitty "$@"
        '')
        pkgs.kitty
      ];
    };
  });
in
if driver == "intel" then nixGLKittyModule nixglPackages.nixGLIntel "nixGLIntel"
else if driver == "nvidia" then
  nixGLKittyModule (nixglPackages.nvidiaPackages { version = nvidiaVersion; }).nixGLNvidia "nixGLNvidia-${nvidiaVersion}"
else throw "Unsupported nixGL driver: ${driver}"
