# Run this file with with 'nix-shell --command "jupyter lab"'
#
# This file uses jupyterWith from https://github.com/tweag/jupyterWith which
# implements reproducible Jupyter lab notebooks. The killer feature of jupyterWith
# is that it allows you to get plots working with e.g. matplotlib or seaborn,
# which did not work for me with the regular 'jupyterlab' derivation in nixpkgs.
#
# Enable plots with the `%matplotlib inline` magic command at the top of the notebook.
# Alternatively, you can do the same thing with `matplotlib.pyplot.ion()`.
#
# Note, that both `%matplotlib widget` and ` %matplotlib notebook` do NOT work.

let
  # Pin nixpkgs
  src = builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/ede6944f4f4b8e6e363a3fcf37b3b8ef4c873783.tar.gz";
      # sha256 = "0lkxj9pkzwxbihn3j5nyk61814m5kshpziagdzicxlns1gn1295i";
  };
  nixpkgs = import src {};

  # Pin jupyterWith
  jupyter = import (builtins.fetchGit {
    url = https://github.com/tweag/jupyterWith;
    rev = "7a6716f0c0a5538691a2f71a9f12b066bce7d55c";
  }) {};

  # The Python kernel that can be selected in the notebook. Make sure to pick the one
  # called "Python3 - datascience" in the notebook.
  iPython = jupyter.kernels.iPythonWith {
    name = "datascience";
    python3 = nixpkgs.python3;

    packages = p: with p; [
          requests
          jupyterlab
          black
          plotly
          pandas
          mypy
          chart-studio
          ipywidgets
          matplotlib
          ipympl
          seaborn
    ];
  };

  # Throw in a Haskell kernel as well, because why not
  iHaskell = jupyter.kernels.iHaskellWith {
    name = "haskell";
    packages = p: with p; [ hvega formatting ];
  };

  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [ iPython iHaskell ];
      extraPackages = p: [p.nodejs];
    };
in
  jupyterEnvironment.env
