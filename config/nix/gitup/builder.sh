source "$stdenv/setup"

_makeWritableBuildDir() {
    local dir_name="$1"
    local parent; parent=$(dirname "$dir_name")
    chmod +w "$parent"
    mkdir -p "$dir_name"
    chmod -w "$parent"
}

derivedPath='./build'
buildPhase() {
    _makeWritableBuildDir GitUp/build
    _makeWritableBuildDir GitUpKit/build
    _makeWritableBuildDir GitUpKit/Third-Party/build

    cd GitUp || return 1
    xcodebuild build \
        CODE_SIGN_IDENTITY='' \
        -scheme 'Application' \
        -target 'Application' \
        -configuration 'Release' \
        -derivedDataPath "$derivedPath"
}

installPhase() {
    mkdir -p "$out/Applications"
    mv "$derivedPath/Build/Products/Release/GitUp.app" "$out/Applications/GitUp.app"
}

genericBuild
