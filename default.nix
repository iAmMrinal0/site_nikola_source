with import <nixpkgs> { };

let
  venvDir = "./.venv";
  pythonPackages = python310Packages;
in pkgs.mkShell rec {
  name = "impurePythonEnv";
  buildInputs = [
    freetype
    lcms2
    libjpeg
    libtiff
    libwebp
    libxml2
    libxslt
    libzip
    openjpeg
    pandoc
    pythonPackages.pillow
    pythonPackages.pip
    pythonPackages.pkgconfig
    pythonPackages.python
    pythonPackages.setuptools
    tcl
    zlib
  ];

  # This is very close to how venvShellHook is implemented, but
  # adapted to use 'virtualenv'
  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)

    if [ -d "${venvDir}" ]; then
      echo "Skipping venv creation, '${venvDir}' already exists"
    else
      echo "Creating new venv environment in path: '${venvDir}'"
      # Note that the module venv was only introduced in python 3, so for 2.7
      # this needs to be replaced with a call to virtualenv
      ${pythonPackages.python.interpreter} -m venv "${venvDir}"
    fi

    # Under some circumstances it might be necessary to add your virtual
    # environment to PYTHONPATH, which you can do here too;
    # PYTHONPATH=$PWD/${venvDir}/${pythonPackages.python.sitePackages}/:$PYTHONPATH

    source "${venvDir}/bin/activate"

    # As in the previous example, this is optional.
    pip install -r requirements.txt
  '';
}
