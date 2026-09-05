case $- in
    *i*) ;;
      *) return;;
esac

SHELL_FILES="$HOME/.shell-config"
SHARED_SHELL_FILES="$SHELL_FILES/shell"
BASH_FILES="$SHELL_FILES/bash"
HOST_FILES="$SHELL_FILES/hosts"

for f in "$SHARED_SHELL_FILES"/*.sh "$BASH_FILES"/*.sh; do
  [ -f "$f" ] && . "$f"
done

HOST_NAME="$(hostname -s)"
for f in "$HOST_FILES"/*"$HOST_NAME".sh; do
  [ -f "$f" ] && . "$f"
done
