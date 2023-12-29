{
  pkgs,
  lib,
  config,
  ...
}: 
let
  httpServer = pkgs.python3.withPackages (ps: with ps; [httpserver]);
in
{
  options.aus = {
    programs.shell = {
      enable = lib.mkEnableOption "Enable shell support";
    };
  };

  config = lib.mkIf config.aus.programs.shell.enable {
    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      history = {
        extended = true;
        ignoreDups = true;
      };
      initExtra = builtins.readFile ./zshrc;
      oh-my-zsh = {
        enable = true;
        plugins = ["git" "docker" "kubectl" "extract" "nix-shell" "notify"];
        extraConfig = ''
        zstyle ':notify:*' error-title "Command failed in #{time_elapsed}"
        zstyle ':notify:*' success-title "Command finished in #{time_elapsed}"
        zstyle ':notify:*' app-name sh
        '';
      };
      shellAliases = {
        a = "php artisan";
        cat="${pkgs.bat}/bin/bat";
        cp = "cp -iv";
        dust="${pkgs.du-dust}/bin/dust -r -b";
        files = "thunar .";
        flatten-folder="mv ./*/**/*(.D) .";
        http-server="${httpServer}/bin/python -m http.server";
        lanplay = "sudo lan-play --relay-server-addr 45.43.195.187:11451";
        ls = "${pkgs.lsd}/bin/lsd";
        mv = "mv -iv";
        rm = "rm -Iv";
      };
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.thefuck = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    aus.omzExtraPlugins = {
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
    };
    aus.extraPaths = [
      "$HOME/.krew/bin"
      "$HOME/go/bin"
      "$HOME/.config/composer/vendor/bin"
      "$HOME/.local/bin"
      "$HOME/.mix/escripts"
    ];
  };
}
