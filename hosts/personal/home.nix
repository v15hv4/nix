{ config, pkgs, inputs, ... }:

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
    pkgs.vlc
    pkgs.tofi
    # pkgs.albert
    pkgs.vscode
    pkgs.spotify
    pkgs.ferdium
    pkgs.obs-studio
    pkgs.openshot-qt
    pkgs.telegram-desktop
    pkgs.google-chrome

    # languages
    pkgs.cargo
    pkgs.clang-tools
    pkgs.clang_12
    pkgs.clangStdenv

    # utils
    pkgs.uv
    pkgs.jq
    pkgs.bat
    pkgs.eza
    pkgs.duf
    pkgs.thefuck

    # stuff
    pkgs.wttrbar

    # other
    inputs.shaman.packages.x86_64-linux.shaman

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
    # ".config/hypr".source = ./dotfiles/hypr;
    # ".config/tofi".source = ./dotfiles/tofi;
    ".config/bspwm".source = ./dotfiles/bspwm;
    ".config/sxhkd".source = ./dotfiles/sxhkd;
    ".config/kitty".source = ./dotfiles/kitty;
    ".config/picom".source = ./dotfiles/picom;
    ".config/polybar".source = ./dotfiles/polybar;
    ".config/gtk-3.0".source = ./dotfiles/gtk-3.0;
    ".config/flameshot".source = ./dotfiles/flameshot;
    # ".config/kanshi".source = ./dotfiles/kanshi;
    # ".config/waybar".source = ./dotfiles/waybar;
    # ".config/swaync".source = ./dotfiles/swaync;

    # ".config/albert.conf".source = ./dotfiles/albert.conf;
    ".config/nvim/init.lua".source = ./dotfiles/nvim/init.lua;

    ".p10k.zsh".source = ./dotfiles/.p10k.zsh;
    ".tmux.conf".source = ./dotfiles/.tmux.conf;

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
    userName  = "v15hv4";
    userEmail = "vishva2912@gmail.com";
    lfs.enable = true;
  };

  # zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" "docker" "docker-compose" "systemd" ];
    };
    enableCompletion = true;
    initExtraBeforeCompInit = ''
      fpath+=~/.zfunc
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';
    initExtra = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
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
      pelf = "patchelf --set-interpreter `nix eval nixpkgs#stdenv.cc.bintools.dynamicLinker --raw`";
    };
  };

  # services.polybar = {
  #   package = pkgs.polybar.override {
  #     alsaSupport = true;
  #     pulseSupport = true;
  #   };
  #   enable = true;
  #   script = "exec polybar &";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
