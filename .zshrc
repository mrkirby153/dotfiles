# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/austin/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    docker
    zsh-autosuggestions
    kubectl
    extract
    notify
    zsh-syntax-highlighting
    nix-shell
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


zstyle ':notify:*' error-title "Command failed in #{time_elapsed}"
zstyle ':notify:*' success-title "Command finished in #{time_elapsed}"
zstyle ':notify:*' app-name sh

alias a="php artisan"


upload() {
    tmpfile=$(mktemp -t uploadXXXX)
    if tty -s; then
        if [ $# -eq 0 ]; then
            echo -e "Usage: $0 <file>"
            return 1;
        fi
        curl --progress-bar -F "file=@$1" https://0x0.st >> $tmpfile
    else
        curl --progress-bar -F 'file=@-' https://0x0.st >> $tmpfile
    fi
    /bin/cat $tmpfile
    xclip -selection clipboard < $tmpfile
    rm -f $tmpfile
}

# Path modification
# export PYTHONPATH=/usr/lib/tensorflow/lib/python3.7:$PYTHONPAtH
export EDITOR=/usr/bin/nvim

update_system() {
    echo "Performing full system upgrade"
    sudo pacman -Syu
    to_remove=$(pacman -Qtdq)
    if [[ ! -v to_remove ]]; then
        echo "Removing orphaned packages"
	sudo pacman -Rns $(pacman -Qtdq) 
    else
        echo "No orphanded packages to remove"
    fi
    echo "System upgrade complete!"
}
# Path modifications
export PATH=$HOME/.krew/bin:/home/austin/AndroidSDK/platform-tools:/home/austin/go/bin:/home/austin/.config/composer/vendor/bin:/home/austin/.local/bin:$HOME/.mix/escripts:$PATH

# Snapd
alias files="thunar ."
CHANGE_MINIKUBE_NONE_USER=true
alias zshcfg="vim ~/.zshrc && source ~/.zshrc"
prompt_context() {}
# Run neofetch if we're not ssh or a nix shell
if ! [ -n "$SSH_CLIENT" ] || ! [ -n "$SSH_TTY" ]; then
    (! [ -n "$IN_NIX_SHELL" ]) && neofetch
else
    # Set up some ssh stuff
    # Utility for launching GUI programs over ssh
    ssh_launch() {
        if [ "$#" -lt 1 ]; then
            echo "Usage: $0 <program>"
            return 1
        fi
        DISPLAY=:0.0 "$@"
    }
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export _Z_DATA=$HOME/.config/z
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
eval $(thefuck --alias)

# Use alt + arrows to navigate words
bindkey "\e$terminfo[kcub1]" backward-word
bindkey "\e$terminfo[kcuf1]" forward-word

alias pa-linein="pactl unload-module module-loopback ; pactl load-module module-loopback source_dont_move=true source=alsa_input.pci-0000_29_00.4.analog-stereo"
#alias jack-linein="jack_connect 'Starship/Matisse HD Audio Controller Analog Stereo:capture_FL' 'Starship/Matisse HD Audio Controller Analog Stereo:playback_FL' && jack_connect 'Starship/Matisse HD Audio Controller Analog Stereo:capture_FR' 'Starship/Matisse HD Audio Controller Analog Stereo:playback_FR'"

if [[ -d /usr/share/fzf  ]];
then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
fi

exprop()
{
xprop | awk '
  /^WM_CLASS/{sub(/.* =/, "instance:"); sub(/,/, "\nclass:"); print}
  /^WM_NAME/{sub(/.* =/, "title:"); print}'
}

alias lanplay="sudo lan-play --netif enp34s0 --relay-server-addr mrkirby153.com:11451"

alias cp="cp -iv" \
        mv="mv -iv" \
        rm="rm -vI"

alias startgdrive="systemctl --user start uop-gdrive.service"
alias ls="lsd"
alias flatten-folder="mv ./*/**/*(.D) ."
alias h="home-manager edit && home-manager switch"


# https://github.com/NixOS/nixpkgs/issues/85823
export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

eval "$(starship init zsh)"
# The following lines were added by compinstall
zstyle :compinstall filename '/home/austin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


if [[ -d "$HOME/.miktex/bin" ]];
then
    export PATH="$HOME/.miktex/bin:$PATH"
fi
alias cat='bat'
alias bsc='/mnt/Seagate/Games/BeatSyncConsole/BeatSyncConsole'
alias clippaste="xclip -selection c -o | curl -F'file=@-' https://0x0.st"
alias paste="curl -F'file=@-' https://0x0.st"
alias dedicated_redis="echo 'Opened 127.0.0.1:6380 -> dedicated:6379' && ssh -N -L 127.0.0.1:6380:localhost:6379 dedicated"
alias nixpkg-repl="nix repl '<nixpkgs>'"
alias vim=nvim

mkcd() {
    mkdir -p $1
    cd $1
}

dmesg() {
    command dmesg -T "$@"
}
journalctl() {
    sudo journalctl "${@:--b}"
}

[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

if [ -f ~/.zshrc.local ];
then
    source ~/.zshrc.local
fi


osx_cargo() {
    [ ! -d "$HOME/Development/osxcross/target/bin" ] && echo "OSXCross not found" && exit 1
    PATH="$HOME/Development/osxcross/target/bin:$PATH" CC=o64-clang CXX=o64-clang++ cargo "$@"
}

if [ -f /usr/bin/switch.sh ]; then
    source /usr/bin/switch.sh
    alias kctx='switch'
    alias kns='switch ns'
fi

export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/mcli mcli

# Generate with "autoload zkbd"then run "zkbd"
TERM_FILE="$HOME/.zkbd/$TERM-${DISPLAY:t}"

if [ -f "$TERM_FILE" ]; then
    source "$TERM_FILE"
    [[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
    [[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
fi


SSH_AGENT_FILE="$HOME/.ssh/ssh_agent"
RUNNING_AGENT=$(pgrep ssh-agent)
if [ -f "$SSH_AGENT_FILE" ]; then
    source "$SSH_AGENT_FILE"

    if [ ! "$RUNNING_AGENT" -eq "$SSH_AGENT_PID" ]; then
        NEED_INIT=1
    fi
else
    NEED_INIT=1
fi

if [ ! -z "$NEED_INIT" ]; then
    echo $(ssh-agent -s) | sed -e 's/echo[ A-Za-z0-9]*;//g' > "$SSH_AGENT_FILE"
    source "$SSH_AGENT_FILE"
    echo "Initialized SSH agent as $SSH_AGENT_PID"
    ssh-add > /dev/null
fi
