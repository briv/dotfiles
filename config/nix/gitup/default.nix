{ stdenv, fetchFromGitHub, pkgs, xcodeenv }:

stdenv.mkDerivation rec {
  name = "gitup-${version}";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "git-up";
    repo = "GitUp";
    rev = "ca12a7b79a80a312246d31fb483ca2eb6e6f3210";
    sha256 = "1yr4mzs9mr328yhyrgdmf52r0jhpx91my6masi320lrgc07jf2x0";
    fetchSubmodules = true;
  };

  buildInputs = [ xcodeenv.xcodewrapper ];
  builder = ./builder.sh;

  patches = [ ./do_not_set_version_in_info_plist.patch ];

  meta = {
    description = "Git interface with efficient shortcuts";
    homepage = http://gitup.co/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.darwin;
  };
}
