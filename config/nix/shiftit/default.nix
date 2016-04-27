{ stdenv, fetchFromGitHub, pkgs, xcodeenv }:

# let xcodeenv = pkgs.xcodeenv.override { version = xcodeVersion; };
stdenv.mkDerivation rec {
  name = "shiftit-${version}";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "fikovnik";
    repo = "ShiftIt";
    rev = "version-${version}";
    sha256 = "0pb6sv1pbscqmc870vb8c932xabq39yqi5diias3s5dfwk8hvx4z";
  };

  buildInputs = [ xcodeenv.xcodewrapper ];
  builder = ./builder.sh;

  meta = {
    description = "Managing window size and position in macOS";
    homepage = https://github.com/fikovnik/ShiftIt;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.darwin;
  };
}
