{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    python310Packages.numpy
    python310Packages.matplotlib
    python310Packages.pandas
    python310Packages.scipy
    python310Packages.ipython
    python310Packages.requests

    python310Packages.notebook
  ];
  shellHook = ''
    jupyter notebook
  '';
}
