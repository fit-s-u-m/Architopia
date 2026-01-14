# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
setopt inc_append_history

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutenvrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutenvrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"
alias history='history 0'

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' '^ulfcd\n'

bindkey -s '^a' '^ubc -lq\n'

bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete


# # fnm
# FNM_PATH="/home/fitsum/.local/share/fnm"
# if [ -d "$FNM_PATH" ]; then
#   export PATH="/home/fitsum/.local/share/fnm:$PATH"
#   eval "`fnm env`"
# fi


# bun completions
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin/:$PATH"
export PATH=" ~/.local/share/coursier/bin:$PATH"
export FLYCTL_INSTALL="/home/fitsum/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# Set pyenv root
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Initialize pyenv
export EDITOR="nvim"

# [ -s "/home/fitsum/.bun/_bun" ] && source "/home/fitsum/.bun/_bun"
#golang
export GOPATH=$HOME/go  
export PATH="$GOPATH/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
export STARSHIP_CONFIG=~/.config/starship/starship.toml
alias q=exit
alias ls="eza --icons"
alias ll="eza -lh --icons --grid --group-directories-first"
alias la="eza -lah --icons --grid --group-directories-first"
alias v=nvim
alias cargow="cargo watch -c -q -w src -x 'run -q'"
alias tree="eza -T --icons"
alias ..="cd .."
-() {
  cd -
}
alias cd="z"
export OBSIDIAN_REST_API_KEY="210a7d0530314ab4130d05c871769073e4afc7e656aadf3f8b5fc01dc6ae8f1e"
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # Optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
function l() {
 local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
 yazi "$@" --cwd-file="$tmp"
 if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
   builtin cd -- "$cwd"
 fi
 rm -f -- "$tmp"
}
# Source carapace completion
source <(carapace _carapace)
# for ocaml
eval "$(opam env)"
fzf_cd() {
    local dir
    dir=$(fzf)  # Use fzf to select a file or directory
    if [[ -n "$dir" ]]; then
        cd "$(dirname "$dir")"  # Change to the directory containing the selected file/directory
    fi
}

# bind the funciton fzf to ctrl + f
zle -N fzf_cd_widget fzf_cd
bindkey '^f' fzf_cd_widget
eval "$(atuin init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
[[ "$(tty)" == /dev/tty1 ]] && Hyprland

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
# eval "$(pyenv virtualenv-init -)"
# fastfetch

. "$HOME/.local/share/../bin/env"
eval "$(uvx --generate-shell-completion zsh)"
