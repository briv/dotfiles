{ stdenv, fetchFromGitHub, lib, xcodeenv, darwinUtils }:

stdenv.mkDerivation rec {
  name = "iterm2-${version}";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "gnachman";
    repo = "iTerm2";
    rev = "v${version}";
    sha256 = "1895b7kph87ncz1ss2wig9gxl3yjp4pc55yn7yvbw6ygyn34qzqi";
  };

  buildInputs = [ xcodeenv.xcodewrapper ];

  # patches = [ ./disable_updates.patch ./do_not_codesign.patch ];

  makeFlagsArray = ["Deployment"];
  preInstall = ''
    for key in 'CFBundleVersion' 'CFBundleShortVersionString' 'CFBundleGetInfoString'; do
      ${darwinUtils}/bin/defaults write \
        "$(pwd)/build/Deployment/iTerm2.app/Contents/Info.plist" "$key" "$version"
    done
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    mv "build/Deployment/iTerm2.app" "$out/Applications/iTerm.app"
  '';

  meta = {
    description = "A replacement for Terminal and the successor to iTerm";
    homepage = https://www.iterm2.com/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.darwin;
  };
}
