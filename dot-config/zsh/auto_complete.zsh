

### compinit {{

zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)		# Include hidden files.

# Set custom location for the completion dump file
mkdir -p "$HOME/.local/state/zsh/"
ZCOMPDUMP_FILE="$HOME/.local/state/zsh/.zcompdump"

# Load compinit — only do a full $fpath scan once per day.
# -C skips the fpath scan and security check, just loads the cached dump.
autoload -Uz compinit
local _zcomp_needs_regen=0
if [[ ! -f "$ZCOMPDUMP_FILE" ]]; then
  _zcomp_needs_regen=1
else
  # (Nmh+24) glob qualifier: matches if file is older than 24 hours.
  # Must be evaluated outside [[ ]] for glob expansion to work.
  local _zcomp_old=(${ZCOMPDUMP_FILE}(Nmh+24))
  (( ${#_zcomp_old} )) && _zcomp_needs_regen=1
fi

if (( _zcomp_needs_regen )); then
  compinit -d "$ZCOMPDUMP_FILE"
  echo "zsh completion cache has been regenerated"
else
  compinit -C -d "$ZCOMPDUMP_FILE"
fi

### }}

# Enable Bash-style completion in Zsh
autoload -Uz bashcompinit && bashcompinit

# gotask autocompletion
# NOTE: On Fedora the binary is go-task rather than task
if which go-task 1> /dev/null 2> /dev/null; then
  alias task="go-task"
fi
# Cache task completions to avoid spawning a subprocess on every shell startup.
# Delete the cache file to regenerate: rm ~/.local/state/zsh/.task-completion.zsh
_TASK_COMP_CACHE="$HOME/.local/state/zsh/.task-completion.zsh"
if [[ ! -f "$_TASK_COMP_CACHE" ]]; then
  task --completion zsh > "$_TASK_COMP_CACHE" 2>/dev/null
fi
[[ -f "$_TASK_COMP_CACHE" ]] && source "$_TASK_COMP_CACHE"

