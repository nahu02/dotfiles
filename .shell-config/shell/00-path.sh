# PATH & toolchain env vars. Sourced by BOTH bash and zsh.
# Every entry is guarded so this is a no-op wherever the tool/dir doesn't exist.

[[ -d "$HOME/.local/bin" ]] && export PATH="$PATH:$HOME/.local/bin"
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$PATH:$HOME/.cargo/bin"
[[ -d "$HOME/flutter/flutter/bin" ]] && export PATH="$PATH:$HOME/flutter/flutter:$HOME/flutter/flutter/bin"
[[ -d "/opt/fabric" ]] && export PATH="$PATH:/opt/fabric"
command -v go > /dev/null 2>&1 && export PATH="$PATH:$(go env GOPATH)/bin"
[[ -d "$HOME/.opencode/bin" ]] && export PATH="$HOME/.opencode/bin:$PATH"

# Android SDK
if [[ -d "$HOME/Android/Sdk" ]]; then
  export ANDROID_HOME="$HOME/Android/Sdk"
  export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
fi

# Java
[[ -d "/opt/jdk-17.0.2" ]] && export JAVA_HOME="/opt/jdk-17.0.2"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Playwright Fedora wrapper
if [ -f "$HOME/.local/share/playwright-fedora/pw.bash" ]; then
  . "$HOME/.local/share/playwright-fedora/pw.bash"
fi

# Colorize man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Editor: vim over SSH, nvim locally if present, vim otherwise
if command -v nvim > /dev/null 2>&1; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi
