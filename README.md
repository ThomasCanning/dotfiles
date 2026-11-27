# dotfiles

My Neovim and tmux config.

- `nvim/` → symlinked to `~/.config/nvim`
- `tmux/.tmux.conf` → symlinked to `~/.tmux.conf`
- `bin/sync.sh` → commits and pushes changes every 30 minutes (via a macOS LaunchAgent)

## Setup on a new machine

```sh
git clone https://github.com/ThomasCanning/dotfiles.git ~/dotfiles
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
```
