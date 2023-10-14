{ fetchFromGitHub, python3Packages, ... }:

with python3Packages;

buildPythonPackage {
  name = "dotbot";
  src = fetchFromGitHub {
    owner = "anishathalye";
    repo = "dotbot";
    rev = "3f9e409669172ad662e82fca791f0ad16dce5edd";
    hash = "sha256-Pb8gY8b4jzTNf8uB3Vve/GQKv2XqCa2GJWHCYnWa2Ug=";
  };

  preBuild = ''
    sed -i 's/6.0.1/6.0/g' setup.py
  '';

  buildInputs = [ pyyaml ];
  propagatedBuildInputs = [ pyyaml ];
}
