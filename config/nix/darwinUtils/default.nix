{ stdenv }:

stdenv.mkDerivation rec {
  name = "darwinutils";

  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup

    mkdir -p $out/bin
    cd $out/bin
    ln -s /usr/bin/defaults
  '';

  meta = {
    description = "Various macOS utilities";
    platforms = stdenv.lib.platforms.darwin;
  };
}
