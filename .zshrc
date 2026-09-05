SHELL_FILES="$HOME/.shell-config"

SHARED_SHELL_FILES="$SHELL_FILES/shell"
ZSH_FILES="$SHELL_FILES/zsh"
HOST_FILES="$SHELL_FILES/hosts"

for f in "$SHARED_SHELL_FILES"/*.sh; do
  # echo "shell: $f"
  [[ -f "$f" ]] && . "$f"
done

for f in "$ZSH_FILES"/*.zsh; do
  # echo "zsh: $f"
  [[ -f "$f" ]] && . "$f"
done

HOST_NAME="$(hostname -s)"

# wrap needed so 0 files does not wrap needed so 0 files does not show errorr 
() {
  setopt localoptions nullglob
  for f in "$HOST_FILES"/*"$HOST_NAME".{sh,zsh}; do
    . "$f"
  done
}
