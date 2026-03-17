brew() {
    command brew "$@"
    local rc=$?
    if [[ $rc -eq 0 ]] && [[ "$1" =~ ^(install|uninstall|remove|reinstall|tap|untap)$ ]]; then
        echo "Updating Brewfile..."
        command brew bundle dump --file="$HOME/code/dotfiles/Brewfile" --force
    fi
    return $rc
}

gt() {
    if [[ "$1" == "new" ]]; then
        local output
        output=$(command gt "$@")
        local rc=$?
        if [[ $rc -eq 0 ]]; then
            local dir
            dir=$(echo "$output" | tail -1)
            if [[ -d "$dir" ]]; then
                echo "$output" | sed '$d'  # Print all output except last line
                cd "$dir"
            else
                echo "$output"
            fi
        else
            echo "$output"
        fi
        return $rc
    else
        command gt "$@"
    fi
}

set_tmux_title() {
  # Only run if we are actually inside a tmux session
  if [ -n "$TMUX" ]; then
    GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ -n "$GIT_ROOT" ]; then
      tmux rename-window "$(basename "$GIT_ROOT")"
    else
      tmux rename-window ""
    fi
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd set_tmux_title
