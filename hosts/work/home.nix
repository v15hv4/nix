{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "v15hv4";
  home.homeDirectory = "/home/v15hv4";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.tofi
    pkgs.telegram-desktop
    (pkgs.google-chrome.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
    })

    # utils
    pkgs.uv
    pkgs.jq
    pkgs.bat
    pkgs.eza
    pkgs.duf

    # languages
    pkgs.cargo

    # stuff
    pkgs.slack
    pkgs.ansible
    pkgs.wttrbar
    pkgs.discord
    pkgs.gcalcli

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/hypr".source = ./dotfiles/hypr;
    ".config/tofi".source = ./dotfiles/tofi;
    ".config/kitty".source = ./dotfiles/kitty;
    ".config/waybar".source = ./dotfiles/waybar;
    ".config/swaync".source = ./dotfiles/swaync;
    ".config/albert.conf".source = ./dotfiles/albert.conf;
    ".config/nvim/init.lua".source = ./dotfiles/nvim/init.lua;
    ".p10k.zsh".source = ./dotfiles/.p10k.zsh;
    ".tmux.conf".source = ./dotfiles/.tmux.conf;

    ".config/kanshi".source = ./dotfiles-local/kanshi;

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/v15hv4/etc/profile.d/hm-session-vars.sh
  
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # git
  programs.git = {
    enable = true;
    userName  = "v-lgns";
    userEmail = "vishva@luganodes.com";
    lfs.enable = true;
  };

  # zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "docker-compose" "systemd" ];
    };
    initExtraBeforeCompInit = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';
    initExtra = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      fpath+=~/.zfunc
      autoload -Uz compinit && compinit
    '';
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    shellAliases = {
      vim = "nvim";
      ls = "eza";
      df = "duf -theme light";
      cat = "bat --theme gruvbox-light";
      rs = "rsync -avzWP";
      dc = "docker compose";

      # nix-specific
      nsh = "nix-shell -p";
      nsn = "nix search nixpkgs ^";
      nre = "sudo nixos-rebuild switch --impure";
      ngc = "sudo nix-collect-garbage --delete-old && sudo nix-store --gc";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
