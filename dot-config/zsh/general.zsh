# Use Neovim for man pages
# :h :Man
export MANPAGER='vv +Man!'
export MANWIDTH=999

# vi mode
bindkey -v
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line
export KEYTIMEOUT=1

export EDITOR=vv
autoload -U edit-command-line
zle -N edit-command-line
# Pressing "e" in vi mode will open the prompt in $EDITOR
bindkey -M vicmd 'e' edit-command-line

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# ^[[3~ is what gets sent when pressing the delete key,
#   map it to delete.
bindkey '^[[3~' delete-char

# Allow comments in interactive shell commands.
setopt INTERACTIVE_COMMENTS

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Increase default shell open file limit
ulimit -n 10240

source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
