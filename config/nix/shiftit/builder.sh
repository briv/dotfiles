source "$stdenv/setup"

buildPhase() {
    cp -R "$src" src
    cd src/ShiftIt
    chmod +w .
    mkdir -p build
    chmod -w .

    xcodebuild -target 'ShiftIt NoX11' -configuration Release
}

installPhase() {
    mkdir -p "$out/Applications"
    mv 'build/Release/ShiftIt.app' "$out/Applications/ShiftIt.app"
}

genericBuild
