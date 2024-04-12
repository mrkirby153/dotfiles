{
  pkgs,
  lib,
  config,
  ...
}: let
  httpServer = pkgs.python3.withPackages (ps: with ps; [httpserver]);
  notifier = pkgs.writeShellScriptBin "notifier" (builtins.readFile ./notifier);
  shellScript = import ../../lib/shellScript.nix {
    inherit (pkgs) writeTextFile runtimeShell;
    inherit pkgs lib;
  };
  nix_index_updater = shellScript {
    name = "nix-index-updater";
    path = ./nix_index_update;
    deps = with pkgs; [
      jq
      curl
      coreutils
    ];
  };
in {
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
      initExtra = ''
        zstyle ':notify:*' notifier "${notifier}/bin/notifier"
        ${builtins.readFile ./zshrc}
      '';
      oh-my-zsh = {
        enable = true;
        plugins = ["git" "docker" "kubectl" "extract"];
      };
      shellAliases = {
        a = "php artisan";
        cat = "${pkgs.bat}/bin/bat";
        cp = "cp -iv";
        dust = "${pkgs.du-dust}/bin/dust -r -b";
        files = "thunar .";
        flatten-folder = "mv ./*/**/*(.D) .";
        http-server = "${httpServer}/bin/python -m http.server";
        lanplay = "sudo lan-play --relay-server-addr 45.43.195.187:11451";
        ls = "${pkgs.lsd}/bin/lsd";
        lg = "lazygit";
        mv = "mv -iv";
        rm = "rm -Iv";
      };
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        line_break.disabled = true;
        status = {
          disabled = false;
          symbol = "✖ ";
        };
        kubernetes.disabled = false;
        time.disabled = false;
      };
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

    programs.nix-index = {
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
      nix-shell = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.7.0";
        sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
      };
      notify = pkgs.fetchFromGitHub {
        owner = "marzocchi";
        repo = "zsh-notify";
        rev = "9c1dac81a48ec85d742ebf236172b4d92aab2f3f";
        sha256 = "sha256-ovmnl+V1B7J/yav0ep4qVqlZOD3Ex8sfrkC92dXPLFI=";
      };
    };
    aus.extraPaths = [
      "$HOME/.krew/bin"
      "$HOME/go/bin"
      "$HOME/.config/composer/vendor/bin"
      "$HOME/.local/bin"
      "$HOME/.mix/escripts"
    ];

    systemd.user.services = {
      "nix-index-update" = {
        Unit = {
          Description = "Updates the nix-index";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${nix_index_updater}/bin/nix-index-updater";
        };
      };
    };

    systemd.user.timers = {
      "nix-index-update" = {
        Unit = {
          Description = "Updates the nix-index";
        };
        Timer = {
          OnCalendar = "Sun *-*-* 00:00:00";
          Persistent = true;
          Unit = "nix-index-update.service";
        };
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
