# Starship
eval "$(starship init zsh)"

# Enalbe fzf autocompletion, keybinding etc.
export FZF_CTRL_R_COMMAND=""
source <(fzf --zsh)

# Better zsh history
eval "$(atuin init zsh --disable-up-arrow)"
