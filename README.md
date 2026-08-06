# fish-dotfiles

Complete kitty + fish terminal setup — pick a color theme, **JetBrainsMono Nerd Font**, **tide v6** prompt (styled by Tide's own official configuration wizard), animated cursor, typewriter greeting, **fastfetch** on every new shell. Exported from macOS, fully portable to Arch Linux with a one-command interactive installer.

---

## Quick start — Arch Linux (one command, guided walkthrough)

```bash
curl -fsSL https://raw.githubusercontent.com/iancrowder23-ship-it/fish-dotfiles/main/install.sh | bash
```

This runs a full interactive walkthrough:

1. **Pick a color theme** (`graphite-emerald` or `catppuccin-mocha`)
2. **Choose optional components** — fastfetch on startup? fisher + plugins? launch the prompt wizard? apply monochrome grey+green prompt colors? set fish as default shell?
3. **Installs packages** via pacman: `kitty`, `fish`, `git`, `curl`, `eza`, `bind` (for `dig`), `libnotify` (for notifications), `fastfetch` (optional), `ttf-jetbrains-mono-nerd`, `noto-fonts-emoji`
4. **Backs up** any existing `~/.config/kitty`, `~/.config/fish`, `~/.config/fastfetch` (timestamped `.bak-` folders)
5. **Deploys colors** for your chosen theme (kitty, fish syntax highlighting, git colors, fastfetch)
6. **Installs** [fisher](https://github.com/jorgebucaran/fisher) and all plugins (tide, autopair, done, puffer-fish)
7. **Launches Tide's own interactive `tide configure` wizard** — this is the real prompt customization system: it walks you through prompt style (Lean/Classic/Rainbow/Powerline), character set, spacing, transient prompt, and segment order. This repo never hand-writes prompt layout — you build it yourself, live, with instant preview.
8. **Optionally applies monochrome prompt colors** — `scripts/tide-colors.fish` runs after the wizard and repaints every segment with alternating dark-grey/light-grey backgrounds and green lettering/icons, on top of whatever layout you just chose. It only touches colors, never items/separators/frame, so it can't undo your layout choices.
9. **Sets fish as your default shell** (if you said yes)

Log out/in (or just open kitty) and everything is ready.

### Non-interactive / scripted install

Skips the walkthrough entirely — useful for a second machine once you already know what you want:

```bash
./install.sh --theme graphite-emerald --yes
./install.sh --theme catppuccin-mocha --no-fastfetch --no-shell-change
./install.sh --list-themes
./install.sh --help
```

| Flag | Effect |
|---|---|
| `-t, --theme <name>` | `graphite-emerald` (default) or `catppuccin-mocha` |
| `-y, --yes` | Accept all defaults, skip the interactive walkthrough entirely |
| `--no-fastfetch` | Skip installing/deploying fastfetch |
| `--no-shell-change` | Don't `chsh` to fish |
| `--no-plugins` | Skip fisher + plugin install (also skips the tide wizard) |
| `--no-tide-wizard` | Skip launching `tide configure` (keeps whatever prompt config you already have) |
| `--mono-green-prompt` | Apply the monochrome grey+green prompt colors (non-interactive) |
| `--no-mono-green-prompt` | Skip the monochrome grey+green prompt colors (non-interactive) |
| `--list-themes` | Print available themes and exit |
| `-h, --help` | Show usage and exit |

Re-run anytime to switch color themes without touching plugins, prompt layout, or your shell:

```bash
./install.sh --theme catppuccin-mocha --no-plugins --no-shell-change
```

Re-run just the prompt wizard anytime, independent of the installer:

```bash
fish -c 'tide configure'
```

Re-apply just the monochrome grey+green prompt colors anytime, independent of the installer (useful after re-running the wizard, since the wizard resets colors to its own defaults). Note: Tide bakes prompt colors into `fish_prompt` at session start, so open a **new** terminal window/tab (or run `exec fish`) afterward to actually see the change:

```bash
fish ~/.local/share/fish-dotfiles/scripts/tide-colors.fish
```

---

## Themes

| Theme | Look |
|---|---|
| **graphite-emerald** *(default)* | Monochrome graphite-to-white base (near-black background, gray/white text), emerald green as the one recurring accent — cursor, git branch, prompt highlights. Purple/magenta only shows up as a rare, muted secondary touch. |
| **catppuccin-mocha** | The original — warm purple/peach Catppuccin Mocha, unchanged |

**Themes only control colors** (kitty palette, fish syntax highlighting, git status colors, fastfetch). **Prompt structure/layout/style is controlled separately by Tide's own `tide configure` wizard** — run it once during install (or anytime after with `fish -c 'tide configure'`) and pick whatever prompt style you like. Optionally, on top of that, `scripts/tide-colors.fish` repaints every prompt segment with a fixed monochrome look — three grey tiers (darkest/mid/light, modeled on Tide's own official presets so segment boundaries stay readable) and green text/icons throughout — independent of which theme or which tide layout you picked.

---

## Repo layout

```
fish-dotfiles/
├── install.sh                       interactive walkthrough installer
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
└── fastfetch/
    ├── graphite-emerald.jsonc       fastfetch layout matching the theme → ~/.config/fastfetch/config.jsonc
    └── catppuccin-mocha.jsonc
└── scripts/
    └── tide-colors.fish             optional: monochrome grey+green colors for ANY tide layout,
                                      run after `tide configure`. Never touches items/separators/frame.
```

Note: there's intentionally no `scripts/tide-<theme>.fish` layout file. Prompt structure comes from `tide configure`, which writes its own settings straight into fish's universal variable store (`fish_variables`) — nothing in this repo needs to duplicate or hand-maintain that. `scripts/tide-colors.fish` is the one exception: it's an optional, purely cosmetic color overlay that works on top of any layout you chose in the wizard.

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

**Prompt** — [tide v6](https://github.com/IlanCosman/tide). Layout/style is entirely up to you via `tide configure` (launched during install, or run `fish -c 'tide configure'` anytime). The wizard asks about:

- Prompt style: Lean, Classic, Rainbow, or Powerline
- Character set: Unicode or ASCII-only
- Prompt color: True color or 256-color
- Spacing: Compact or Sparse
- Icons: many icons or few
- Prompt height: one line or two lines
- Left/right frame: enabled or bordered
- Transient prompt: on or off

Whatever you pick, it uses the colors from your installed theme.

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

Runs automatically at the end of `fish_greeting` (every new interactive shell) if installed. Config is theme-matched: `fastfetch/<name>.jsonc` → deployed to `~/.config/fastfetch/config.jsonc`. Boxed layout (`┌─┤─└`) with per-row Nerd Font icons and keys colored in the theme's accent, values in the theme's foreground gray. Shows user@host, OS, kernel, uptime, packages, shell, terminal, CPU, GPU, memory, disk, local IP, and a color swatch bar. Skip it entirely with `--no-fastfetch`.

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
| Tide prompt layout | set via `tide configure` | same — run `fish -c 'tide configure'` on either OS |

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
fish -c 'tide configure'   # walks you through prompt style interactively

# set fish as default shell
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

---

## Troubleshooting

**Icons show as boxes/question marks** — the Nerd Font isn't active. Run `fc-cache -f`, restart kitty, and confirm `kitty +list-fonts | grep -i jetbrains` shows the font.

**Prompt looks plain / custom prompt missing** — tide didn't install or hasn't been configured yet. Fix from inside fish:

```fish
fisher install ilancosman/tide@v6
tide configure
exec fish
```

Check `fisher list` to see which plugins are actually installed.

**Want to change your prompt style/layout later** — just run `fish -c 'tide configure'` again anytime; it overwrites your previous answers.

**Prompt shows raw text like `3A3A3A` instead of your path/icons** — you're seeing stale prompt state from before colors finished applying, or you're still in the same session that ran `scripts/tide-colors.fish`. Tide bakes its color codes into `fish_prompt` once at session start — it does **not** re-read `tide_*_color` variables on every render. Fix: close the terminal and open a new one, or run `exec fish`. Just running `source` or reloading config is not enough.

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

The installer is idempotent — safe to re-run any time, including just to switch color themes (`--no-plugins --no-shell-change` skips re-running the prompt wizard and shell change).
