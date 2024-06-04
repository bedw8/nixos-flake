

{ pkgs, ... }:
with pkgs;
[
  #texlive.combined.scheme-medium
  nix-index
  tesseract
  conda
  file
  tesseract
  tk
  cairo
  graphviz
  gephi
  julia
  #sageWithDoc
  #python311Packages.graph-tool
  (python3.withPackages (ps: with ps; [
    numpy
    pandas
    openpyxl
    seaborn
    tkinter
    matplotlib.override {enableQt = true;}
    xlib
    requests
    beautifulsoup4
    typer
    fastapi
    lxml
    igraph
    #tensorflow
    scikit-learn
    jupyter
    ipython
    plotly
    pytorch
    pygraphviz
    pygobject3
    ipympl
    pynvim
    pyperclip
 #   graph-tool
    ]))
]
