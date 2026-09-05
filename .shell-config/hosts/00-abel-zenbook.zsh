# This file must match `hostname -s` on the machine it belongs to
# Only device-specific go here

command -v fastfetch > /dev/null && [[ "$TERM_PROGRAM" != "vscode" ]] && fastfetch

# Drift terminal screensaver
command -v drift > /dev/null && [[ "$TERM_PROGRAM" != "vscode" ]] && eval "$(drift shell-init zsh)"

# dhcpdump on this machine's Wi-Fi interface - interface name varies per host,
# so this alias can't safely be shared/guarded generically.
alias dhcpdump="sudo tcpdump -i wlo1 -nev udp port 68"

# zoxide init is not at the end of .zshrc, due to how the dotfiles are split - so warning msg is disabled.
export _ZO_DOCTOR=0

export TERMCMD=ghostty