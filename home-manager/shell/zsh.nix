{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}: let
  notifier = pkgs.writeShellScriptBin "notifier" (builtins.readFile ./scripts/notifier);
  httpServer = pkgs.python3.withPackages (ps: with ps; [httpserver]);

  kubecolor = pkgs-unstable.kubecolor.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "kubecolor";
      repo = "kubecolor";
      rev = "v0.4.0";
      sha256 = "sha256-jOFeTAfV7X8+z+DBOBOFVcspxZ8QssKFWRGK9HnqBO0=";
    };
    vendorHash = "sha256-b99HAM1vsncq9Q5XJiHZHyv7bjQs6GGyNAMONmGpxms=";
  });
in {
  config = lib.mkIf config.aus.programs.shell.enable {
    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      history = {
        extended = true;
        ignoreDups = true;
      };
      initExtra = ''
        ${lib.strings.optionalString pkgs.stdenv.hostPlatform.isLinux "zstyle ':notify:*' notifier \"${lib.getExe notifier}\""}
        ${builtins.readFile ./scripts/zshrc}
      '';
      oh-my-zsh = {
        enable = true;
        plugins = ["git" "docker" "kubectl" "extract"];
      };
      shellAliases = {
        a = "php artisan";
        cat = "${lib.getExe pkgs.bat}";
        cp = "cp -iv";
        dust = "${lib.getExe pkgs.du-dust} -r -b";
        files = "thunar .";
        flatten-folder = "mv ./*/**/*(.D) .";
        http-server = "${lib.getExe httpServer} -m http.server";
        lanplay = "sudo lan-play --relay-server-addr 45.43.195.187:11451";
        ls = "${lib.getExe pkgs.lsd}";
        lg = "lazygit";
        mv = "mv -iv";
        kubectl = "${lib.getExe kubecolor}";
        rm = "rm -Iv";
      };
    };

    aus.omzExtraPlugins = lib.mkMerge [
      {
        zsh-syntax-highlighting = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "sha256-gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
        };
        zsh-autosuggestions = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "a411ef3e0992d4839f0732ebeb9823024afaaaa8";
          sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
        nix-shell = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.7.0";
          sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
        };
      }
      (lib.mkIf
        pkgs.stdenv.hostPlatform.isLinux
        {
          notify = pkgs.fetchFromGitHub {
            owner = "marzocchi";
            repo = "zsh-notify";
            rev = "9c1dac81a48ec85d742ebf236172b4d92aab2f3f";
            sha256 = "sha256-ovmnl+V1B7J/yav0ep4qVqlZOD3Ex8sfrkC92dXPLFI=";
          };
        })
    ];
    aus.extraPaths = [
      "$HOME/.krew/bin"
      "$HOME/go/bin"
      "$HOME/.config/composer/vendor/bin"
      "$HOME/.local/bin"
      "$HOME/.mix/escripts"
      "$HOME/.cargo/bin"
    ];
  };
}
