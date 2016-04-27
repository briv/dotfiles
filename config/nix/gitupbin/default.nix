{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "gitupbin-${version}";
  version = "1.0.9";

  src = fetchurl {
    url = "https://s3-us-west-2.amazonaws.com/gitup-builds/stable/GitUp.zip";
    sha256 = "0zy0p33jdiy4yhhygccyajd6khn93xlnc9q0zmcsbj4rgxmkzm59";
  };

  buildInputs = [ unzip ];

  buildCommand = ''
    mkdir -p "$out/Applications"
    unzip -d $out/Applications $src
  '';

  meta = {
    description = "Git interface with efficient shortcuts";
    homepage = http://gitup.co/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.darwin;
  };
}

