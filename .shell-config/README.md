# dotfiles

Shared shell config, synced across laptop / home server / work servers via a
bare git repo (`config` alias, work-tree = `$HOME`). Not every tool exists on
every machine, so everything here is guarded and safe to source blindly.

## Layout

- `shell/*.sh` — bash/zsh-compatible (not necessarily POSIX). Sourced by **both** bash (`~/.bashrc`)
  and zsh (`~/.zshrc`). Numeric prefix (`00-`, `10-`, `20-`) controls load
  order — `path.sh` must load before `aliases.sh`/`functions.sh` since alias
  guards depend on PATH already being set.
- `zsh/*.zsh` — zsh-only (bindkeys, hooks, `setopt`, OMZ/p10k). Sourced only   from `~/.zshrc`.
- `hosts/*.zsh` / `hosts/*.sh` — device-specific, matched by filename ending in `$(hostname -s)`. `.sh` variants load from both shells, `.zsh` only from zsh. Missing file for a host = no-op.

## Loaders

`~/.zshrc` and `~/.bashrc` are thin — they just glob and source `shell/`, `zsh/` (zsh only), and the current host's file. No machine-specific logic lives in the loaders themselves.

## Adding a new host

Drop a `hosts/<prefix->hostname.zsh` (or `.sh`) file. Nothing else changes.
