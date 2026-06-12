# fish-dotfiles

Kitty + fish setup — Catppuccin Mocha, JetBrainsMono Nerd Font, tide v6 prompt, animated cursor and greeting. Exported from macOS, fully portable to Arch Linux.

## Arch Linux — one command

```bash
curl -fsSL https://raw.githubusercontent.com/iancrowder23-ship-it/fish-dotfiles/main/install.sh | bash
```

This installs kitty, fish, git, eza, dig (bind), libnotify, JetBrainsMono Nerd Font and emoji fonts via pacman, backs up any existing `~/.config/{kitty,fish}`, deploys these configs, installs fisher + plugins (tide v6, autopair, done, puffer-fish), restores the exact tide prompt theme, and sets fish as your default shell.

## What's inside

```
kitty/
  kitty.conf        shared config (theme, font, layout, keybinds)
  os-linux.conf     Linux overrides  → installed as os.conf by install.sh
  os-macos.conf     macOS overrides  → copy to ~/.config/kitty/os.conf on a Mac
fish/
  config.fish       aliases, abbreviations, env, git prompt (cross-platform)
  fish_plugins      fisher plugin list
  conf.d/animations.fish    cursor morph animation + syntax highlight colors
  functions/        fish_greeting (typewriter banner), mkcd, reload
scripts/
  tide-config.fish  exact tide v6 theme export (161 universal variables)
install.sh          Arch one-command setup
```

## macOS ↔ Arch differences handled

- **Shell path**: `/opt/homebrew/bin/fish` (Mac) vs `/usr/bin/fish` (Arch) — split into `os.conf`.
- **Homebrew PATH**: only added when `/opt/homebrew` exists.
- **`ip` alias**: on Mac, `ip` shows your public IP; on Linux it is *not* aliased (so iproute2 still works) — use `myip` instead. `ipl` (local IP) is implemented per-OS.
- **Keybindings**: kitty maps `cmd` to the Super key on Linux, so all shortcuts carry over; `ctrl+shift+c/v` copy/paste is added on Linux. All `macos_*` options are ignored on Linux.
- **Font**: installed via `ttf-jetbrains-mono-nerd` (pacman) instead of Homebrew cask.
- **`done` plugin notifications**: uses `libnotify`/`notify-send` on Linux (installed by the script).
- **Tide theme**: tide stores its config in fish universal variables which fisher does NOT sync — `scripts/tide-config.fish` restores the full theme exactly.

## macOS setup (manual)

```bash
brew install fish kitty eza
brew install --cask font-jetbrains-mono-nerd-font
cp -r fish/ ~/.config/fish/
cp kitty/kitty.conf ~/.config/kitty/kitty.conf
cp kitty/os-macos.conf ~/.config/kitty/os.conf
fish -c 'curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update'
fish scripts/tide-config.fish
```
