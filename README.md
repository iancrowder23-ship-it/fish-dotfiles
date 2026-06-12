# fish-dotfiles

Complete kitty + fish terminal setup — **Catppuccin Mocha** theme, **JetBrainsMono Nerd Font**, **tide v6** prompt, animated cursor, typewriter greeting. Exported from macOS, fully portable to Arch Linux with a one-command installer.

---

## Quick start — Arch Linux (one command)

```bash
curl -fsSL https://raw.githubusercontent.com/iancrowder23-ship-it/fish-dotfiles/main/install.sh | bash
```

That's it. The script does everything:

1. Installs packages via pacman: `kitty`, `fish`, `git`, `curl`, `eza`, `bind` (for `dig`), `libnotify` (for notifications), `ttf-jetbrains-mono-nerd`, `noto-fonts-emoji`
2. Backs up any existing `~/.config/kitty` and `~/.config/fish` (timestamped `.bak-` folders)
3. Deploys all configs from this repo
4. Refreshes the font cache
5. Installs [fisher](https://github.com/jorgebucaran/fisher) and all plugins
6. Restores the exact tide prompt theme (161 universal variables)
7. Sets fish as your default shell

Log out/in (or just open kitty) and everything is ready.

---

## Repo layout

```
fish-dotfiles/
├── install.sh                  one-command Arch Linux installer
├── kitty/
│   ├── kitty.conf              shared config — theme, font, layout, keybinds
│   ├── os-linux.conf           Linux overrides  → installed as os.conf by install.sh
│   └── os-macos.conf           macOS overrides  → copy to ~/.config/kitty/os.conf on a Mac
├── fish/
│   ├── config.fish             env, PATH, git prompt, aliases, abbreviations
│   ├── fish_plugins            fisher plugin list
│   ├── conf.d/
│   │   └── animations.fish     cursor morph animation, exit-status flash, syntax colors
│   └── functions/
│       ├── fish_greeting.fish  typewriter welcome banner (purple→orange gradient)
│       ├── mkcd.fish           mkdir + cd in one
│       └── reload.fish         reload fish config
└── scripts/
    └── tide-config.fish        exact tide v6 theme export — run after fisher install
```

---

## What you get

### Kitty terminal

- **Theme**: Catppuccin Mocha with 0.92 background opacity + blur (frosted glass)
- **Font**: JetBrainsMono Nerd Font Mono, 13.5pt
- **Cursor**: animated beam with trail (`cursor_trail 3`)
- **Tabs**: powerline-style tab bar (round separators, bottom edge)
- **Layouts**: splits, tall, stack — toggle zoom with `cmd+shift+z`
- **10,000 lines** scrollback, copy-on-select enabled

### Kitty keybindings

`cmd` = ⌘ on macOS, **Super/Win key** on Linux (kitty maps it automatically).

| Keys | Action |
|---|---|
| `cmd+c` / `cmd+v` | copy / paste (Linux also: `ctrl+shift+c/v`) |
| `cmd+t` / `cmd+w` | new tab (same cwd) / close tab |
| `cmd+]` / `cmd+[` | next / previous tab |
| `cmd+1…9` | go to tab 1–9 |
| `cmd+d` / `cmd+shift+d` | vertical / horizontal split (same cwd) |
| `ctrl+cmd+arrows` | move between panes |
| `ctrl+cmd+shift+arrows` | resize pane (`ctrl+cmd+0` reset) |
| `cmd+shift+z` | toggle zoom (stack layout) |
| `cmd+n` / `cmd+shift+w` | new / close OS window |
| `cmd+=` / `cmd+-` / `cmd+0` | font size up / down / reset |
| `cmd+k` | clear terminal + scrollback |
| `cmd+shift+a` / `cmd+shift+s` | background opacity up / down |
| `cmd+shift+f` | fullscreen |
| `cmd+left/right` | jump to start / end of line |
| `alt+left/right` | jump by word |
| `cmd+backspace` | delete to start of line |
| `ctrl+cmd+,` | reload kitty config |

### Fish shell

**Prompt** — [tide v6](https://github.com/IlanCosman/tide), two-line powerline:

- Left: OS icon · path · git status · prompt character
- Right: exit status · command duration · user@host · jobs · node/python/java/ruby versions · time
- Custom purple/orange Catppuccin accent colors (full theme in `scripts/tide-config.fish`)

**Plugins** (managed by fisher, listed in `fish_plugins`):

| Plugin | What it does |
|---|---|
| [tide v6](https://github.com/IlanCosman/tide) | the prompt |
| [autopair](https://github.com/jorgebucaran/autopair.fish) | auto-close `()` `[]` `{}` `""` |
| [done](https://github.com/franciscolourenco/done) | desktop notification when commands >5s finish |
| [puffer-fish](https://github.com/nickeb96/puffer-fish) | text expansions: `!!`, `...`, `$$` |

**Animations** (`conf.d/animations.fish`):

- Cursor morphs beam → underline → block when you hit Enter, back to blinking beam after
- Green `✓` / red `✗ exit N` flash after every command
- Catppuccin Mocha syntax highlighting (mauve commands, peach args, orange flags)

**Greeting** — typewriter animation: *"❯ Welcome back, Ian ❯"* in a purple→orange gradient, plus kitty/fish version info.

### Aliases

| Alias | Expands to |
|---|---|
| `ls`, `ll` | `eza -lagh --icons --group-directories-first` |
| `l` | compact eza listing |
| `la` | eza sorted by modified time |
| `tree` | `eza -Ta --icons` (ignores node_modules/.git) |
| `cp`, `mv`, `rm` | interactive (confirm before clobber) |
| `..`, `...`, `....`, `.....` | up 1–4 directories |
| `g`, `ga`, `gc`, `gp`, `gs`, `gd`, `gl` | git add/commit/push/status/diff/log |
| `myip` | public IP (via OpenDNS) |
| `ipl` | local IP (per-OS implementation) |
| `mkcd <dir>` | mkdir + cd |
| `reload` | restart fish |

### Abbreviations (expand as you type)

`mk`→`mkdir -p` · `rmf`→`rm -rf` · `py`→`python3` · `pip`→`pip3` · `ni`→`npm install` · `ns`→`npm start` · `nd`→`npm run dev` · `nb`→`npm run build`

---

## macOS ↔ Arch differences (all handled)

| Thing | macOS | Arch Linux |
|---|---|---|
| fish path | `/opt/homebrew/bin/fish` | `/usr/bin/fish` (via `os.conf`) |
| Homebrew PATH | added | skipped (dir doesn't exist) |
| `ip` alias | public IP | **not aliased** — keeps iproute2 working; use `myip` |
| `ipl` (local IP) | `ipconfig getifaddr en0` | `ip -4 addr` based |
| Font install | Homebrew cask | `ttf-jetbrains-mono-nerd` (pacman) |
| `done` notifications | macOS Notification Center | `notify-send` / libnotify |
| `macos_*` kitty options | active | silently ignored |
| Keybindings | ⌘ | Super key + extra `ctrl+shift+c/v` |
| Tide theme | universal vars in `fish_variables` | restored by `scripts/tide-config.fish` (fisher does **not** sync these) |

---

## macOS setup (manual)

```bash
brew install fish kitty eza
brew install --cask font-jetbrains-mono-nerd-font

git clone https://github.com/iancrowder23-ship-it/fish-dotfiles.git
cd fish-dotfiles
cp -r fish/ ~/.config/fish/
mkdir -p ~/.config/kitty
cp kitty/kitty.conf ~/.config/kitty/kitty.conf
cp kitty/os-macos.conf ~/.config/kitty/os.conf

fish -c 'curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update'
fish scripts/tide-config.fish

# set fish as default shell
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

---

## Troubleshooting

**Icons show as boxes/question marks** — the Nerd Font isn't active. Run `fc-cache -f`, restart kitty, and confirm `kitty +list-fonts | grep -i jetbrains` shows the font.

**Prompt looks plain after install** — tide variables didn't apply. Run `fish scripts/tide-config.fish` from the repo (clone lives at `~/.local/share/fish-dotfiles` if you used the one-liner), then `exec fish`.

**`done` notifications don't appear** — you need a notification daemon (`dunst`, `mako`, or your DE's built-in). `libnotify` only provides the client side.

**Shell didn't change** — run `chsh -s /usr/bin/fish` manually, then log out/in.

**Restore old configs** — the installer saved them: `~/.config/kitty.bak-<timestamp>` and `~/.config/fish.bak-<timestamp>`.

**Transparency/blur missing on Linux** — `background_blur` needs a compositor that supports it (KDE, Hyprland, picom). It's cosmetic; everything else works without it.

---

## Updating

Configs changed on one machine? Commit + push, then on the other machine:

```bash
cd ~/.local/share/fish-dotfiles && git pull && ./install.sh
```

The installer is idempotent — safe to re-run any time.
