# bash-only behavior: history, prompt, dircolors, completion.
# Sourced only from ~/.bashrc

# --- History -----------------------------------------------------------------
HISTCONTROL=ignoreboth   # ignorespace + ignoredups: skip commands starting with a
                         # space, and skip repeats of the previous command
shopt -s histappend      # append to ~/.bash_history on exit instead of overwriting
                         # it (keeps history from parallel shells)
HISTSIZE=1000            # commands kept in memory for the running shell
HISTFILESIZE=2000        # lines kept on disk in ~/.bash_history

# --- Terminal ----------------------------------------------------------------
shopt -s checkwinsize    # re-check LINES/COLUMNS after every command, so bash
                         # rewraps correctly when the window is resized

# Teach `less` to page non-text files (archives, PDFs, images)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# If available, run fastfetch (not in VS Code)
command -v fastfetch > /dev/null && [[ "$TERM_PROGRAM" != "vscode" ]] && fastfetch

# --- Prompt ------------------------------------------------------------------
# Decide whether the terminal can do color
color_prompt=
if command -v tput >/dev/null 2>&1 && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
    color_prompt=yes
else
    case "$TERM" in
        *color*|xterm*|rxvt*|screen*|tmux*|alacritty*|kitty*|foot*|wezterm*|st-*|linux|ansi|cygwin) color_prompt=yes ;;
    esac
fi

# Prompt palette.
# On a terminal without color every entry is the empty string.
#
# __p_git/__p_dim/__p_off are the contract with semi_git_prompt in
# shell/20-functions.sh.
#
# Each escape is wrapped in \001/\002 (aka. \[\]), to mark non-printing.
# Note 90-97 (bright) are the aixterm extension rather than strict ANSI, and
# SGR 2 (dim) is unevenly implemented; both are ignored when terminals lack them.
if [ "$color_prompt" = yes ]; then
    __p_user=$'\001\e[92m\002'      # bright green -> username
    __p_host=$'\001\e[0;33m\002'    # yellow       -> hostname
    __p_cwd=$'\001\e[97m\002'       # bright white -> working directory
    __p_git=$'\001\e[0;36m\002'     # cyan         -> repo name and branch
    __p_dim=$'\001\e[0;2;37m\002'   # dim white    -> @ and the < / > punctuation
    __p_ind=$'\001\e[37m\002'       # white        -> the final $
    __p_off=$'\001\e[0m\002'        # reset all, so commands use default colors
else
    __p_user= __p_host= __p_cwd= __p_git= __p_dim= __p_ind= __p_off=
fi
unset color_prompt

# Single-line prompt:  user@host cwd <repo/branch> $
#
# \u = username, \h = hostname up to the first dot (\H is the full FQDN),
# \w = cwd, \$ = '#' when root, '$' otherwise.
PS1="${__p_user}\\u${__p_dim}@${__p_host}\\h${__p_off} ${__p_cwd}\\w${__p_off} \$(semi_git_prompt)${__p_ind}\\\$${__p_off} "

# Prefix PS1 with an OSC 0 escape that sets the window title to cwd.
# The excluded terminals have no OSC parser.
case "$TERM" in
    dumb|linux|cons25|emacs|eterm*) ;;
    *) PS1="\[\e]0;\w\a\]$PS1" ;;
esac

# --- Colors for coreutils ----------------------------------------------------
if [ -x /usr/bin/dircolors ]; then
    # Load ~/.dircolors if present, else the built-in defaults
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# --- Completion --------------------------------------------------------------
# Skip when bash is in POSIX mode, where completion scripts' bashisms would break
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
