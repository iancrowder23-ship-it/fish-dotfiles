# fish-dotfiles

Complete kitty + fish terminal setup — pick a theme, **JetBrainsMono Nerd Font**, **tide v6** prompt, animated cursor, typewriter greeting, **fastfetch** on every new shell. Exported from macOS, fully portable to Arch Linux with a one-command interactive installer.

---

## Quick start — Arch Linux (one command)

```bash
curl -fsSL https://raw.githubusercontent.com/iancrowder23-ship-it/fish-dotfiles/main/install.sh | bash
```

You'll be prompted to pick a color theme, whether to enable fastfetch, and whether to set fish as your default shell. The script then does everything else:

1. Installs packages via pacman: `kitty`, `fish`, `git`, `curl`, `eza`, `bind` (for `dig`), `libnotify` (for notifications), `fastfetch` (optional), `ttf-jetbrains-mono-nerd`, `noto-fonts-emoji`
2. Backs up any existing `~/.config/kitty`, `~/.config/fish`, `~/.config/fastfetch` (timestamped `.bak-` folders)
3. Deploys configs for your chosen theme
4. Refreshes the font cache
5. Installs [fisher](https://github.com/jorgebucaran/fisher) and all plugins
6. Applies the matching tide prompt theme (161 universal variables)
7. Sets fish as your default shell (if you said yes)

Log out/in (or just open kitty) and everything is ready.

### Non-interactive / scripted install

```bash
./install.sh --theme graphite-emerald --yes
./install.sh --theme catppuccin-mocha --no-fastfetch --no-shell-change
./install.sh --list-themes
./install.sh --help
```

| Flag | Effect |
|---|---|
| `-t, --theme <name>` | `graphite-emerald` (default) or `catppuccin-mocha` |
| `-y, --yes` | Accept all defaults, skip interactive prompts |
| `--no-fastfetch` | Skip installing/deploying fastfetch |
| `--no-shell-change` | Don't `chsh` to fish |
| `--no-plugins` | Skip fisher + plugin install (also skips the tide theme apply) |
| `--list-themes` | Print available themes and exit |
| `-h, --help` | Show usage and exit |

Re-run anytime to switch themes without touching plugins or your shell:

```bash
./install.sh --theme catppuccin-mocha --no-plugins --no-shell-change
```

---

## Themes

| Theme | Look |
|---|---|
| **graphite-emerald** *(default)* | Modern dark-graphite background, purple/peach accents (carried over from the original look), emerald green used sparingly — cursor, git status, success states only |
| **catppuccin-mocha** | The original — warm purple/peach Catppuccin Mocha, unchanged |

Each theme bundles matching colors for kitty, the fish prompt (tide), fish syntax highlighting, the greeting gradient, and fastfetch — switching themes re-colors the whole stack consistently.

---

## Repo layout

```
fish-dotfiles/
├── install.sh                       fancy interactive Arch Linux installer
├── kitty/
│   ├── kitty.conf                   shared config — font, layout, keybinds; includes theme.conf
│   ├── os-linux.conf                Linux overrides  → installed as os.conf by install.sh
│   ├── os-macos.conf                macOS overrides  → copy to ~/.config/kitty/os.conf on a Mac
│   └── themes/
│       ├── graphite-emerald.conf    kitty colors → installed as theme.conf
│       └── catppuccin-mocha.conf
├── fish/
│   ├── config.fish                  env, PATH, git prompt, aliases, abbreviations
│   ├── fish_plugins                 fisher plugin list
│   ├── conf.d/
│   │   └── animations.fish          cursor morph animation, exit-status flash
│   ├── themes/
│   │   ├── graphite-emerald.fish    syntax colors, git colors, greeting gradient → conf.d/00-theme.fish
│   │   └── catppuccin-mocha.fish
│   └── functions/
│       ├── fish_greeting.fish       typewriter welcome banner (theme gradient) + fastfetch
│       ├── mkcd.fish                mkdir + cd in one
│       └── reload.fish              reload fish config
├── fastfetch/
│   ├── graphite-emerald.jsonc       fastfetch layout matching the theme → ~/.config/fastfetch/config.jsonc
│   └── catppuccin-mocha.jsonc
└── scripts/tide/
    ├── graphite-emerald.fish        exact tide v6 theme export per color theme
    └── catppuccin-mocha.fish
```

---

## What you get

### Kitty terminal

- **Font**: JetBrainsMono Nerd Font Mono, 13.5pt
- **Cursor**: animated beam with trail (`cursor_trail 3`)
- **Tabs**: powerline-style tab bar (round separators, bottom edge)
- **Layouts**: splits, tall, stack — toggle zoom with `cmd+shift+z`
- **10,000 lines** scrollback, copy-on-select enabled
- Colors come from `kitty/themes/<name>.conf`, installed as `~/.config/kitty/theme.conf` and pulled in via `include theme.conf` at the bottom of `kitty.conf`

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
- Colors come from `scripts/tide/<name>.fish`, run once by install.sh after fisher installs tide

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
- Syntax highlighting colors come from `fish/themes/<name>.fish` (installed as `conf.d/00-theme.fish`, loads before `animations.fish`)

**Greeting** — typewriter animation: *"❯ Welcome back, Ian ❯"* using the active theme's gradient, kitty/fish version info, followed by **fastfetch** system info (if enabled).

### fastfetch

Runs automatically at the end of `fish_greeting` (every new interactive shell) if installed. Config is theme-matched: `fastfetch/<name>.jsonc` → deployed to `~/.config/fastfetch/config.jsonc`. Shows OS, host, kernel, uptime, packages, shell, terminal, CPU, GPU, memory, disk, local IP, and a color swatch bar. Skip it entirely with `--no-fastfetch`.

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
| Tide theme | universal vars in `fish_variables` | restored by `scripts/tide/<name>.fish` (fisher does **not** sync these) |

---

## macOS setup (manual)

```bash
brew install fish kitty eza
brew install --cask font-jetbrains-mono-nerd-font

git clone https://github.com/iancrowder23-ship-it/fish-dotfiles.git
cd fish-dotfiles

# pick a theme, e.g. graphite-emerald
THEME=graphite-emerald

cp -r fish/ ~/.config/fish/
cp "fish/themes/$THEME.fish" ~/.config/fish/conf.d/00-theme.fish
mkdir -p ~/.config/kitty
cp kitty/kitty.conf ~/.config/kitty/kitty.conf
cp kitty/os-macos.conf ~/.config/kitty/os.conf
cp "kitty/themes/$THEME.conf" ~/.config/kitty/theme.conf
mkdir -p ~/.config/fastfetch
cp "fastfetch/$THEME.jsonc" ~/.config/fastfetch/config.jsonc

fish -c 'curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update'
fish "scripts/tide/$THEME.fish"

# set fish as default shell
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

---

## Troubleshooting

**Icons show as boxes/question marks** — the Nerd Font isn't active. Run `fc-cache -f`, restart kitty, and confirm `kitty +list-fonts | grep -i jetbrains` shows the font.

**Prompt looks plain / custom prompt missing** — tide didn't install or its theme didn't apply. Fix from inside fish (swap in whichever theme you're using):

```fish
fisher install ilancosman/tide@v6
curl -fsSL https://raw.githubusercontent.com/iancrowder23-ship-it/fish-dotfiles/main/scripts/tide/graphite-emerald.fish | fish
exec fish
```

Check `fisher list` to see which plugins are actually installed.

**Prompt path truncation throws `string shorten: unknown option`** — this was a bug in an earlier version where `tide_git_truncation_strategy` held a literal `…` character instead of an empty string. Fixed in `scripts/tide/*.fish` — re-run the tide theme script above to pick up the fix.

**`done` notifications don't appear** — you need a notification daemon (`dunst`, `mako`, or your DE's built-in). `libnotify` only provides the client side.

**Shell didn't change** — run `chsh -s /usr/bin/fish` manually, then log out/in.

**Restore old configs** — the installer saved them: `~/.config/{kitty,fish,fastfetch}.bak-<timestamp>`.

**Transparency/blur missing on Linux** — `background_blur` needs a compositor that supports it (KDE, Hyprland, picom). It's cosmetic; everything else works without it.

---

## Updating

Configs changed on one machine? Commit + push, then on the other machine:

```bash
cd ~/.local/share/fish-dotfiles && git pull && ./install.sh
```

The installer is idempotent — safe to re-run any time, including just to switch themes.
