# Portable aliases. Sourced by BOTH bash and zsh. Every tool-based alias is
# guarded with command -v so it's harmless on machines missing the tool

command -v exa > /dev/null && alias ls='exa --group-directories-first' && alias tree='exa --tree'
command -v eza > /dev/null && alias ls='eza --group-directories-first' && alias tree='eza --tree'
command -v lsd > /dev/null && alias ls='lsd --group-dirs first' && alias tree='lsd --tree'

command -v batcat > /dev/null && alias bat='batcat'  # Ubuntu's bat package is called batcat
command -v bat > /dev/null && alias cat='bat --pager=never' && alias less='bat'

command -v htop > /dev/null && alias top='htop'
command -v btop > /dev/null && alias top='btop'

command -v git > /dev/null && alias glog='git --no-pager log --all --graph --decorate --pretty --color=always | tac'

command -v rg > /dev/null && alias grep='rg -uu'

command -v gnome-text-editor > /dev/null && alias gedit='gnome-text-editor'

command -v yt-dlp > /dev/null && alias youtube-dl='yt-dlp'

command -v timr-tui > /dev/null && alias timer='timr-tui' && alias timr='timr-tui'

command -v go-chromecast > /dev/null && alias chromecast=go-chromecast

if command -v flatpak > /dev/null; then
	flatpak info com.visualstudio.code > /dev/null 2>&1 && alias code="flatpak run com.visualstudio.code"
	flatpak info com.usebottles.bottles > /dev/null 2>&1 && alias bottles-cli="flatpak run --command=bottles-cli com.usebottles.bottles"
fi

alias l='ls -la'
alias ll='ls -l'
alias la='ls -lA'

# Bare-repo dotfiles manager (this file lives inside that repo's work-tree)
alias config='/usr/bin/git --git-dir=$HOME/.shared-conf/ --work-tree=$HOME'
