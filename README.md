# dotfiles

Personal configuration files for my development environment (macOS & Linux).

This repository sets up a consistent environment across machines using a bash script to install dependencies (Neovim, Tmux, Starship, etc.) and symlink configuration files.

## Structure

The repository mirrors the structure of the `$HOME` directory:

* `setup.bash` - The installation script.
* `.zshrc` - Shell configuration.
* `.tmux.conf` - Tmux configuration.
* `.config/` - App-specific configurations:
    * `nvim/init.lua`
    * `alacritty/alacritty.toml`
    * `starship.toml`

# Installation

```bash
git clone https://github.com/Nathene/dotfiles.git
```

give bash script permission to execute

```bash
chmod +x setup.bash
./install.sh
```

