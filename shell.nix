{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    python39
    python39Packages.numpy
    python39Packages.matplotlib
    python39Packages.pandas
    python39Packages.scipy
    python39Packages.ipython
    python39Packages.requests
    python39Packages.z3
    python39Packages.notebook
  ];
  shellHook = ''
    jupyter notebook
  '';
}
