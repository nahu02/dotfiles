Shared dotfiles to be used on multiple environments.
This should only include non-environment specific configs.

Setup heavily inspired by [this article](https://www.atlassian.com/git/tutorials/dotfiles).

## Setup on a new machine

```bash
git clone --bare https://github.com/nahu02/dotfiles "$HOME/.shared-conf"

alias config='git --git-dir="$HOME/.shared-conf" --work-tree="$HOME"'

config sparse-checkout set --no-cone '/*' '!/README.md'
config checkout
config config --local status.showUntrackedFiles no
```
