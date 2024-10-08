{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "quellen";
  home.homeDirectory = "/home/quellen";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.rustup
    pkgs.htop
    pkgs.btop

    # Node
    pkgs.fnm
    
    pkgs.zip
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
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/quellen/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.git = {
    enable = true;

    userName = "quellen-sol";
    userEmail = "quellen@step.finance";

    signing = {
      key = "/home/quellen/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    ignores = [
      ".qexclude*"
    ];

    delta = {
      enable = true;
    };

    extraConfig = {
      core = {
        editor = "code --wait";
      };

      gpg = {
        format = "ssh";
      };
    };
  };

  programs.starship = {
    enable = true;

    settings = {
      add_newline = true;

      git_branch = {
        format = "on [$branch]($style) ";
      };

      git_status = {
        ahead = "⇡ $count";
        behind = "⇣ $count";
      };

      nodejs = {
        disabled = true;
      };

      aws = {
        disabled = true;
      };
    };
  };

  programs.bash = {
    enable = true;

    profileExtra = "
      # if running bash
      if [ -n \"$BASH_VERSION\" ]; then
          # include .bashrc if it exists
          if [ -f \"$HOME/.bashrc\" ]; then
        . \"$HOME/.bashrc\"
          fi
      fi
    ";

    initExtra = "
      # If not running interactively, don't do anything
      case $- in
          *i*) ;;
            *) return;;
      esac

      # don't put duplicate lines or lines starting with space in the history.
      # See bash(1) for more options
      HISTCONTROL=ignoreboth

      # append to the history file, don't overwrite it
      shopt -s histappend

      # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
      HISTSIZE=1000
      HISTFILESIZE=2000

      # check the window size after each command and, if necessary,
      # update the values of LINES and COLUMNS.
      shopt -s checkwinsize

      # enable color support of ls and also add handy aliases
      if [ -x /usr/bin/dircolors ]; then
          test -r ~/.dircolors && eval \"$(dircolors -b ~/.dircolors)\" || eval \"$(dircolors -b)\"
          alias ls='ls --color=auto'
          #alias dir='dir --color=auto'
          #alias vdir='vdir --color=auto'

          alias grep='grep --color=auto'
          alias fgrep='fgrep --color=auto'
          alias egrep='egrep --color=auto'
      fi

      # enable programmable completion features (you don't need to enable
      # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
      # sources /etc/bash.bashrc).
      if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
          . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
          . /etc/bash_completion
        fi
      fi

      export PATH=/home/quellen/dev/bin:$PATH
      export PATH=/home/quellen/dev/archipelago-bot/target/release:$PATH
      export PATH=/home/quellen/.cargo/bin/:$PATH
      export PATH=/home/quellen/.local/share/solana/install/active_release/bin:$PATH

      eval \"$(fnm env --use-on-cd --shell bash)\"

      eval $(starship init bash)
    ";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
