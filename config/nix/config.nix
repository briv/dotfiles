{
  allowUnsupportedSystem = true;

  packageOverrides = pkgs: rec {

    caddy = pkgs.buildGoModule rec {
      pname = "caddy";
      version = "2.0.0-rc.3";

      goPackagePath = "github.com/caddyserver/caddy";

      subPackages = [ "cmd/caddy" ];

      src = pkgs.fetchFromGitHub {
        owner = "caddyserver";
        repo = pname;
        rev = "v${version}";
        sha256 = "1jsjh8q5wsnp7j7r1rlnw0w4alihpcmpmlpqncmhik10f6v7xm3y";
      };
      modSha256 = "0n0k0w9y2z87z6m6j3sxsgqn9sm82rdcqpdck236fxj23k4akyp6";
    };

    personalSystemEnv = let
      # see https://github.com/nix-community/NUR to fix the revision of NUR
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
      # linuxkit-builder needs to be built on linux so there's a chicken and egg problem here on macOS.
      # linuxkit-builder = (import (builtins.fetchGit {
      #   url = "https://github.com/nix-community/linuxkit-nix";
      #   rev = "cb2259cb2892c428f666c82e158e4d702db6b858";
      #   ref = "master";
      # }) {
      #   inherit pkgs;
      # }).linuxkit-builder;
    in
      pkgs.buildEnv {
        name = "personalSystemEnv-0.1";
        paths = builtins.concatLists (
          builtins.attrValues (
            with pkgs; {
              core = [
                ripgrep
                neovim
                git
                fzf
                direnv
                fd
                bat
                julia_13 # slightly broken package management, had to download the registry manually
              ];
              utils = [
                aspell aspellDicts.fr aspellDicts.en # spell check
                cloc
                jq
                watch
              ];
              # TODO: use "cached-nix-shell", see https://github.com/xzfc/cached-nix-shell, to build up
              # a better nixify ?
              dev = [
                nur.repos.kalbasit.nixify
                niv
                nixpkgs-fmt
                shellcheck
              ];
              tmux = [ tmux reattach-to-user-namespace ];
              # building-docker-images = [ linuxkit-builder ];
              # vimPlugins = [ vimPlugins.fzfWrapper ];
            }
          )
        );
      };

    keybase = pkgs.lib.overrideDerivation pkgs.keybase (
      oldAttrs: {
        postInstall = ''
          install_name_tool -delete_rpath $out/lib -add_rpath $bin $bin/bin/keybase
        '';
      }
    );
  };
}
