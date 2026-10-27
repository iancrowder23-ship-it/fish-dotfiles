# fish-dotfiles

kitty + fish setup for **Arch Linux**: JetBrainsMono Nerd Font, [Starship](https://starship.rs) prompt, animated cursor, typewriter greeting, fastfetch. Colors come from **kitty's built-in theme browser** (hundreds of themes), and everything else follows whichever theme you pick.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/iancrowder23-ship-it/fish-dotfiles/main/install.sh | bash
```

or from a clone: `./install.sh`

The installer asks a few questions, installs packages with pacman, backs up `~/.config/{kitty,fish,fastfetch}` (copied to `.bak-<timestamp>`, nothing is moved), deploys the configs, installs fisher + plugins, then opens the color picker.

Re-running it is safe. Your universal variables, plugins and kitty theme are preserved, and so is a `~/.config/starship.toml` you wrote yourself. Machines upgraded from the old tide setup get tide removed automatically.

| Flag | Effect |
|---|---|
| `-y, --yes` | No questions, use defaults |
| `--theme "<name>"` | kitty theme to apply without the browser (e.g. `"Tokyo Night"`) |
| `--accent <color>` | `red` `green` `yellow` `blue` `magenta` `cyan` |
| `--no-fastfetch` | Don't install/run fastfetch |
| `--no-plugins` | Skip fisher + plugins |
| `--no-shell-change` | Don't `chsh` to fish |

## Colors: `theme-pick`

```fish
theme-pick                          # browse kitty themes, then pick an accent
theme-pick "Gruvbox Dark"           # set a theme by name
theme-pick --accent blue            # change only the accent, no browser
```

1. `kitten themes` sets the terminal's 16 ANSI colors. It writes `~/.config/kitty/themes.conf`, never `kitty.conf`.
2. You pick one of the theme's colors as the **accent**. It's stored as `$dotfiles_accent`.
3. The Starship prompt is synced to the theme: `theme-pick` reads the kitty theme file and writes its exact colors into the prompt palette. The accent is the theme's own shade, and segment backgrounds are the theme background lightened toward its foreground, so they sit on the theme instead of on `color0`, which many themes make darker than the background.
4. fish syntax highlighting, fastfetch and the greeting use ANSI color names plus the accent, so they follow the theme automatically.

If you change the theme some other way (plain `kitten themes`, or editing the theme file), the next new shell notices and re-syncs the prompt (`conf.d/theme-sync.fish`).

## Prompt

`~/.config/starship.toml` is a two-line rounded powerline prompt: OS + user, directory, git, language versions, and command duration on the right. Every color comes from the `[palettes.dotfiles]` table at the bottom. Only that table gets rewritten when the theme syncs, so edit the layout freely ([config docs](https://starship.rs/config/)).

To use one of Starship's presets instead, run `starship preset --list`, then `starship preset <name> -o ~/.config/starship.toml`. Presets have their own fixed colors, so `theme-pick` will leave the prompt alone after that. Re-run the installer to get the theme-following prompt back.

## What's included

**fish** — `config.fish` (env, aliases, abbreviations), `conf.d/colors.fish` (syntax/git/greeting colors), `conf.d/animations.fish` (cursor morphs beam → underline → block on Enter; ✓ / ✗ exit flash after each command), `fish_greeting` (typewriter banner + fastfetch), `mkcd`, `reload`, `theme-pick`.

**Plugins** (`fish_plugins`, managed by the `fisher` package): autopair · done (desktop notification for commands >5s) · puffer-fish.

**Aliases**: `ls`/`ll`/`l`/`la`/`tree` (eza) · `cp`/`mv`/`rm` interactive · `..` to `.....` · `g ga gc gp gs gd gl` · `myip` · `ipl` · abbreviations `mk rmf py pip ni ns nd nb`.

**kitty** — 13.5pt JetBrainsMono Nerd Font, cursor trail, powerline tab bar, 0.92 opacity + blur, splits layout.

### kitty keys (`kitty_mod` = ctrl+shift)

| Keys | Action |
|---|---|
| `kitty_mod+c` / `v` | copy / paste |
| `kitty_mod+t` / `q` | new tab (same cwd) / close tab |
| `kitty_mod+left` / `right`, `alt+1…9` | previous / next tab, go to tab |
| `kitty_mod+d` / `kitty_mod+alt+d` | vertical / horizontal split (same cwd) |
| `kitty_mod+w` | close pane |
| `kitty_mod+alt+arrows` | move between panes |
| `kitty_mod+r` | resize pane |
| `kitty_mod+alt+z` | zoom pane |
| `kitty_mod+alt+k` | clear screen + scrollback |
| `kitty_mod+equal` / `minus` / `backspace` | font size up / down / reset |
| `kitty_mod+a` then `m` / `l` | opacity up / down |
| `kitty_mod+f11` / `f5` | fullscreen / reload config |
| `alt+left` / `right` | jump by word |

## Troubleshooting

- **Icons show as boxes**: run `fc-cache -f`, restart kitty, then check `kitty +list-fonts | grep -i jetbrains`.
- **Prompt is plain**: check that starship is installed (`pacman -S starship`), then open a new shell.
- **No `done` notifications**: you need a notification daemon (dunst, mako, or your DE's).
- **No blur**: `background_blur` needs compositor support (KDE, Hyprland, …). It's purely cosmetic.
- **pacman 404s**: your package database is stale. Run `sudo pacman -Syu` and re-run the installer.
- **Restore old configs**: `~/.config/{kitty,fish,fastfetch}.bak-<timestamp>`.

## Layout

```
install.sh
kitty/kitty.conf              → ~/.config/kitty/kitty.conf (includes themes.conf)
fish/                         → ~/.config/fish/
starship/starship.toml        → ~/.config/starship.toml
fastfetch/config.jsonc.in     → rendered to ~/.config/fastfetch/config.jsonc with your accent
```
