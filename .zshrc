# Source aliases
[ -f ~/.aliases ] && source ~/.aliases

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Zsh Completion
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true
compinit

# Plugins (Mac Homebrew Paths)
if [ -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
fi

# Starship Prompt
eval "$(starship init zsh)"

function newalias() {
    # 1. Check if we have enough arguments
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: newalias <name> <command>"
        return 1
    fi

    # 2. Append the new alias to the config file
    # We use >> to append to the end of the file
    echo "alias $1='$2'" >> ~/.aliases

    # 3. Reload the config so it works immediately
    source ~/.zshrc

    echo "✅ Alias '$1' created and loaded!"
}
