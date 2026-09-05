# zsh-only behavior: framework, prompt, keybindings, hooks, zsh-specific functions.
# Sourced only from ~/.zshrc

# Oh My Zsh + Powerlevel10k, with a plain fallback prompt if OMZ isn't installed
OMZ="$HOME/.oh-my-zsh"
if [[ -d "$OMZ" ]]; then
  export OMZ
  ZSH_THEME="powerlevel10k/powerlevel10k"
  plugins=(git zsh-syntax-highlighting zsh-autosuggestions virtualenv zsh-fzf-history-search)
  source "$OMZ/oh-my-zsh.sh"
else
  unset OMZ
  # No OMZ/p10k here, so use shared default prompt:
  #   user@host cwd <git_repo/branch> %#
  # semi_git_prompt lives in shell/20-functions.sh and is shared with bash; it
  # reads __p_git/__p_dim/__p_off. 
  if [[ $(tput colors 2>/dev/null || echo 0) -ge 8 ]]; then
    __p_user=$'%{\e[92m%}'      # bright green -> username
    __p_host=$'%{\e[0;33m%}'    # yellow       -> hostname
    __p_cwd=$'%{\e[97m%}'       # bright white -> working directory
    __p_git=$'%{\e[0;36m%}'     # cyan         -> repo name and branch
    __p_dim=$'%{\e[0;2;37m%}'   # dim white    -> @ and the < / > punctuation
    __p_ind=$'%{\e[37m%}'       # white        -> the final %#
    __p_off=$'%{\e[0m%}'        # reset
  else
    __p_user= __p_host= __p_cwd= __p_git= __p_dim= __p_ind= __p_off=
  fi
  # PROMPT_SUBST is what makes $(...) run at each prompt
  setopt PROMPT_SUBST
  PROMPT="${__p_user}%n${__p_dim}@${__p_host}%m${__p_off} ${__p_cwd}%~${__p_off} \$(semi_git_prompt)${__p_ind}%#${__p_off} "

  # Window/tab title. OMZ does this and does so better
  case "$TERM" in
    dumb|linux|cons25|emacs|eterm*) ;;
    *)
      autoload -U add-zsh-hook
      __set_term_title() { print -Pn '\e]0;%~\a' }
      add-zsh-hook precmd __set_term_title
      ;;
  esac
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Navigational keybindings
bindkey '^[[2~' overwrite-mode
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3;5~' kill-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history

# Auto-activate python venv on cd
activate_venv_on_cd() {
  local venv_names=(".venv" "venv" "env")
  if [[ -n "$_ZSH_AUTO_VENV_ROOT" ]] && [[ "$PWD/" != "$_ZSH_AUTO_VENV_ROOT/"* ]]; then
    deactivate
    unset _ZSH_AUTO_VENV_ROOT
  fi
  for venv_name in "${venv_names[@]}"; do
    if [[ -d "$PWD/$venv_name" ]]; then
      if [[ "$VIRTUAL_ENV" != "$PWD/$venv_name" ]]; then
        source "$PWD/$venv_name/bin/activate"
        export _ZSH_AUTO_VENV_ROOT="$PWD"
      fi
      break
    fi
  done
}
autoload -U add-zsh-hook
add-zsh-hook chpwd activate_venv_on_cd
activate_venv_on_cd

# VS Code shell integration
[[ "$TERM_PROGRAM" == "vscode" ]] && command -v code > /dev/null && . "$(code --locate-shell-integration-path zsh)"

# zoxide init
command -v zoxide > /dev/null && eval "$(zoxide init zsh --cmd cd)"
