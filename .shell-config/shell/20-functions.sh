# Functions that use only bash/zsh-common syntax
# Sourced by BOTH bash and zsh

# mkcd command that creates directory then changes into it
mkcd ()
{
  mkdir -- "$1" && cd -- "$1"
}

# cdl command that enters into a directory then lists its contents
cdl ()
{
  cd -- "$1" && ls
}

speed_up_mp3() {
  if [ $# -ne 2 ]; then
    echo "Usage: speed_up_mp3 <input_file.mp3> <tempo>"
    echo "Example: speed_up_mp3 DoC_Ep_02_-_Chat_Show.mp3 1.5"
    return 1
  fi

  input_file="$1"
  tempo="$2"
  output_file="${input_file%.mp3}-${tempo}x.mp3"

  original_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 -sexagesimal "$input_file" | cut -d. -f1)

  if ffmpeg -v quiet -stats -i "$input_file" -filter:a "atempo=$tempo" "$output_file"; then
    new_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 -sexagesimal "$output_file" | cut -d. -f1)
    echo "Duration change: ${original_duration} => ${new_duration}"
    echo "Successfully created: $output_file"
  else
    echo "An error occurred during processing."
  fi
}

# Yazi file browser wrapper - cd's to wherever yazi ends up on exit (if yazi installed)
if command -v yazi > /dev/null; then
  y() {
    local tmp cwd
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
  }
fi

# regex cheat sheet
# Every argument below is quoted, so nothing globs and no noglob/nomatch guards
# are needed. Use printf, not echo: zsh's echo expands backslash escapes and
# bash's does not.
regex() {
  local CYAN=$'\e[1;36m'
  local YELLOW=$'\e[1;33m'
  local RESET=$'\e[0m'

  printf '%s\n' "${CYAN}REGEX CHEAT SHEET${RESET}"
  printf '\n'
  printf '%s\n' "${YELLOW}Character Ranges${RESET}"
  printf '\n'
  printf '%-10s %-20s %-20s %-30s\n' "Range" "Character Class" "Regex" "Full Set"
  printf '%-10s %-20s %-20s %-30s\n' "-----" "---------------" "-----" "----------------"
  printf '%-10s %-20s %-20s %-30s\n' "space" "" "\\x20" "\\040"
  printf '%-10s %-20s %-20s %-30s\n' "!-/" "" "[\\x21-\\x2F]" "!\"#\$%&'()*+-./"
  printf '%-10s %-20s %-20s %-30s\n' "0-9" "[[:digit:]]" "[\\x30-\\x39]" "0123456789"
  printf '%-10s %-20s %-20s %-30s\n' ":-@" "" "[\\x3A-\\x40]" ":;<=>?@"
  printf '%-10s %-20s %-20s %-30s\n' "A-Z" "[[:upper:]]" "[\\x41-\\x5A]" "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  printf '%-10s %-20s %-20s %-30s\n' "\\-@" "" "[\\x5B-\\x60]" "\\'^_\`"
  printf '%-10s %-20s %-20s %-30s\n' "a-z" "[[:lower:]]" "[\\x61-\\x7A]" "abcdefghijklmnopqrstuvwxyz"
  printf '%-10s %-20s %-20s %-30s\n' "{-~" "" "[\\x7B-\\x7E]" "{|}~"
  printf '%-10s %-20s %-20s %-30s\n' "delete" "" "\\x7F" "\\177"
  printf '\n'
  printf '%s\n' "${YELLOW}Character Classes${RESET}"
  printf '%s\n' "Note: These character classes must be enclosed in additional square brackets."
  printf '\n'
  printf '%-15s %-70s\n' "Class" "Meaning"
  printf '%-15s %-70s\n' "-----" "-------"
  printf '%-15s %-70s\n' "[:alpha:]" "Any letter [A-Za-z]"
  printf '%-15s %-70s\n' "[:upper:]" "Any uppercase letter [A-Z]"
  printf '%-15s %-70s\n' "[:lower:]" "Any lowercase letter [a-z]"
  printf '%-15s %-70s\n' "[:digit:]" "Any digit [0-9]"
  printf '%-15s %-70s\n' "[:alnum:]" "Any alphanumeric character [A-Za-z0-9]"
  printf '%-15s %-70s\n' "[:xdigit:]" "Any hexadecimal digit [0-9A-Fa-f]"
  printf '%-15s %-70s\n' "[:space:]" "A tab, new line, vertical tab, form feed, carriage return, or space"
  printf '%-15s %-70s\n' "[:blank:]" "A space or a tab"
  printf '%-15s %-70s\n' "[:print:]" "Any printable character"
  printf '%-15s %-70s\n' "[:punct:]" "Any punctuation character: !\"#\$%&'()*+,-./:;<=>?@[/]^_\`{|}~"
  printf '%-15s %-70s\n' "[:graph:]" "Any printable character except space class"
  printf '%-15s %-70s\n' "[:word:]" "Continuous string of alphanumeric characters and underscores"
  printf '%-15s %-70s\n' "[:ascii:]" "ASCII characters in the range: 0-127"
  printf '%-15s %-70s\n' "[:cntrl:]" "Any character not part of other classes"
  printf '\n'
  printf '%s\n' "${YELLOW}Regex Composition${RESET}"
  printf '\n'
  printf '%-15s %-25s %-45s\n' "Operator" "Description" "Example"
  printf '%-15s %-25s %-45s\n' "--------" "-----------" "-------"
  printf '%-15s %-25s %-45s\n' "^" "Start of line" "^abc matches 'abc' at start of line"
  printf '%-15s %-25s %-45s\n' "$" "End of line" "abc$ matches 'abc' at end of line"
  printf '%-15s %-25s %-45s\n' "|" "OR operator" "a|b matches 'a' or 'b'"
  printf '%-15s %-25s %-45s\n' "()" "Grouping" "(abc) groups pattern 'abc'"
  printf '%-15s %-25s %-45s\n' "[^...]" "Negation in class" "[^0-9] matches any non-digit"
  printf '%-15s %-25s %-45s\n' "." "Any character" "a.c matches 'abc', 'adc', etc."
  printf '%-15s %-25s %-45s\n' "?" "0 or 1 occurrence" "colou?r matches 'color' or 'colour'"
  printf '%-15s %-25s %-45s\n' "*" "0 or more" "ab*c matches 'ac', 'abc', 'abbc', etc."
  printf '%-15s %-25s %-45s\n' "+" "1 or more" "ab+c matches 'abc', 'abbc', etc."
  printf '%-15s %-25s %-45s\n' "{n}" "Exactly n times" "a{3} matches 'aaa'"
  printf '%-15s %-25s %-45s\n' "{n,}" "n or more times" "a{2,} matches 'aa', 'aaa', etc."
  printf '%-15s %-25s %-45s\n' "{n,m}" "n to m times" "a{2,4} matches 'aa', 'aaa', 'aaaa'"
  printf '%-15s %-25s %-45s\n' "\\b" "Word boundary" "\\bword\\b matches exact word 'word'"
  printf '%-15s %-25s %-45s\n' "\\B" "Not word boundary" "\\Bword matches 'keyword' not 'word'"
  printf '%-15s %-25s %-45s\n' "(?=...)" "Positive lookahead" "a(?=b) matches 'a' only if followed by 'b'"
  printf '%-15s %-25s %-45s\n' "(?!...)" "Negative lookahead" "a(?!b) matches 'a' not followed by 'b'"
  printf '%-15s %-25s %-45s\n' "\\d" "Digit" "\\d matches any digit like [0-9]"
  printf '%-15s %-25s %-45s\n' "\\D" "Non-digit" "\\D matches any non-digit like [^0-9]"
  printf '%-15s %-25s %-45s\n' "\\w" "Word character" "\\w matches [a-zA-Z0-9_]"
  printf '%-15s %-25s %-45s\n' "\\W" "Non-word character" "\\W matches anything not in \\w"
}

# Git segment for the shell prompt: prints "<repo/branch> " when the current
# directory is inside a git work tree, empty string when it is not.
#
# Colors are NOT hardcoded here, because bash and zsh mark up non-printing
# characters differently (bash uses \001/\002, zsh uses %{ %}). Instead this
# reads three variables that each shell sets in its own dialect:
#
#   __p_git   color for the repo name and the branch
#   __p_dim   color for the < / > punctuation
#   __p_off   reset
#
# Unset or empty means no color at all, for monochrome terminals.
#
# This reads git's on-disk state directly (no calling git), so it is Fast.
# Tradeoff: It ignores $GIT_DIR and cross-filesystem discovery (rarely relevant).
semi_git_prompt() {
  local dir root gitdir head ref

  # Walk up from $PWD looking for a .git
  dir=$PWD
  while :; do
    if [ -e "$dir/.git" ]; then
      root=$dir
      break
    fi
    [ -z "$dir" ] && break
    dir=${dir%/*}
  done
  [ -n "$root" ] || return 0

  if [ -d "$root/.git" ]; then
    gitdir=$root/.git
  else
    # Submodule or linked worktree: .git is a file holding "gitdir: <path>",
    # which may be relative to the work tree.
    read -r _ gitdir < "$root/.git" || :
    case $gitdir in
      /*|'') ;;
      *) gitdir=$root/$gitdir ;;
    esac
  fi
  [ -n "$gitdir" ] || return 0

  # "ref: refs/heads/main" on a branch, a raw SHA when detached. A repo with no
  # commits still has a valid HEAD pointing at the unborn branch.
  read -r head < "$gitdir/HEAD" 2>/dev/null || return 0
  case $head in
    'ref: refs/heads/'*) ref=${head#ref: refs/heads/} ;;
    'ref: '*)            ref=${head#ref: } ;;
    *)                   ref=${head:0:7} ;;
  esac

  printf '%s<%s%s%s/%s%s%s>%s ' \
    "$__p_dim" "$__p_git" "${root##*/}" \
    "$__p_dim" "$__p_git" "$ref" \
    "$__p_dim" "$__p_off"
}
