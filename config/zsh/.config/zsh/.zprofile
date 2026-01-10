
# >>> coursier install directory >>>
# Set pyenv root
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

export PATH="$PATH:/home/fitsum/.local/share/coursier/bin"
# <<< coursier install directory <<<
