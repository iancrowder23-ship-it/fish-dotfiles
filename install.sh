#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════
#  fish-dotfiles — Arch Linux installer (kitty + fish + starship)
#
#    curl -fsSL https://raw.githubusercontent.com/iancrowder23-ship-it/fish-dotfiles/main/install.sh | bash
#    ./install.sh --help
# ════════════════════════════════════════════════════════════════
set -euo pipefail

REPO_URL="https://github.com/iancrowder23-ship-it/fish-dotfiles.git"
CLONE_DIR="$HOME/.local/share/fish-dotfiles"

usage() {
    cat <<'EOF'
Usage: install.sh [options]

  -y, --yes             accept defaults, no questions
      --theme <name>    kitty theme name for non-interactive runs
                        (e.g. "Tokyo Night"; see `kitten themes`)
      --accent <color>  red | green | yellow | blue | magenta | cyan
      --dms             follow DankMaterialShell's wallpaper colors
                        instead of a kitty theme
      --no-fastfetch    don't install/run fastfetch
      --no-plugins      skip fisher + plugins (autopair, done, puffer-fish)
      --no-shell-change don't chsh to fish
  -h, --help            show this help

Re-pick colors anytime from fish with: theme-pick
EOF
}

# ── Output helpers ───────────────────────────────────────────
if [[ -t 1 ]]; then
    C_RESET=$'\033[0m'; C_BOLD=$'\033[1m'; C_DIM=$'\033[2m'
    C_ACC=$'\033[32m'; C_RED=$'\033[31m'; C_YEL=$'\033[33m'; C_GRAY=$'\033[90m'
else
    C_RESET=""; C_BOLD=""; C_DIM=""; C_ACC=""; C_RED=""; C_YEL=""; C_GRAY=""
fi

step() { printf '\n%s%s❯%s %s%s%s\n' "$C_BOLD" "$C_ACC" "$C_RESET" "$C_BOLD" "$*" "$C_RESET"; }
info() { printf '  %s·%s %s\n' "$C_GRAY" "$C_RESET" "$*"; }
ok()   { printf '  %s✓%s %s\n' "$C_ACC" "$C_RESET" "$*"; }
warn() { printf '  %s!%s %s\n' "$C_YEL" "$C_RESET" "$*"; }
die()  { printf '  %s✗%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; exit 1; }

# Prompts read from /dev/tty, so they work under `curl | bash`
# (where stdin is the pipe, not the keyboard).
HAVE_TTY=0
if ( : </dev/tty ) 2>/dev/null; then HAVE_TTY=1; fi

ask_yn() {
    # ask_yn "question" default(y|n) -> returns 0 for yes
    local q="$1" def="${2:-y}" ans suffix
    [[ "$def" == y ]] && suffix="[Y/n]" || suffix="[y/N]"
    printf '  %s❯%s %s %s%s%s ' "$C_ACC" "$C_RESET" "$q" "$C_DIM" "$suffix" "$C_RESET"
    read -r ans </dev/tty || ans=""
    [[ "${ans:-$def}" =~ ^[Yy] ]]
}

# ── Parse args ──────────────────────────────────────────────
ASSUME_YES=0
THEME=""
ACCENT=""
DO_DMS=0
DO_FASTFETCH=1
DO_PLUGINS=1
DO_SHELL_CHANGE=1

while [[ $# -gt 0 ]]; do
    case "$1" in
        -y|--yes)          ASSUME_YES=1; shift ;;
        --theme)           [[ $# -ge 2 ]] || die "--theme needs a value"; THEME="$2"; shift 2 ;;
        --accent)          [[ $# -ge 2 ]] || die "--accent needs a value"; ACCENT="$2"; shift 2 ;;
        --dms)             DO_DMS=1; shift ;;
        --no-fastfetch)    DO_FASTFETCH=0; shift ;;
        --no-plugins)      DO_PLUGINS=0; shift ;;
        --no-shell-change) DO_SHELL_CHANGE=0; shift ;;
        -h|--help)         usage; exit 0 ;;
        *)                 die "Unknown option: $1 (see --help)" ;;
    esac
done

if [[ -n "$ACCENT" && ! " red green yellow blue magenta cyan " =~ " $ACCENT " ]]; then
    die "Unknown accent '$ACCENT' (red | green | yellow | blue | magenta | cyan)"
fi

INTERACTIVE=0
[[ $ASSUME_YES -eq 0 && $HAVE_TTY -eq 1 ]] && INTERACTIVE=1

# ── Sanity checks ────────────────────────────────────────────
command -v pacman >/dev/null 2>&1 || die "pacman not found — this script targets Arch Linux."
[[ $EUID -ne 0 ]] || die "Run as your normal user, not root (sudo is used where needed)."
command -v sudo >/dev/null 2>&1 || die "sudo not found — install it and add yourself to sudoers."

printf '\n%s%sfish-dotfiles%s — kitty + fish + starship for Arch Linux\n' "$C_BOLD" "$C_ACC" "$C_RESET"

# ── Questions ────────────────────────────────────────────────
if [[ $INTERACTIVE -eq 1 ]]; then
    step "Options"
    ask_yn "Install fastfetch and run it on every new shell?" y && DO_FASTFETCH=1 || DO_FASTFETCH=0
    ask_yn "Install fisher + plugins (autopair, done, puffer-fish)?" y && DO_PLUGINS=1 || DO_PLUGINS=0
    ask_yn "Set fish as your default login shell?" y && DO_SHELL_CHANGE=1 || DO_SHELL_CHANGE=0
    if [[ $DO_DMS -eq 0 && -f "$HOME/.config/kitty/dank-theme.conf" && -z "$THEME" ]]; then
        ask_yn "DankMaterialShell detected — follow its wallpaper colors instead of a kitty theme?" y && DO_DMS=1
    fi
fi

# ── 1. Packages ──────────────────────────────────────────────
step "Installing packages"
# bind → dig (myip alias) · libnotify → `done` plugin notifications
PKGS=(kitty fish starship git curl eza bind libnotify ttf-jetbrains-mono-nerd noto-fonts-emoji)
[[ $DO_FASTFETCH -eq 1 ]] && PKGS+=(fastfetch librsvg)   # librsvg → rsvg-convert renders the logo tile
[[ $DO_PLUGINS -eq 1 ]] && PKGS+=(fisher)   # packaged in extra; fish_plugins no longer lists fisher itself
sudo pacman -S --needed --noconfirm "${PKGS[@]}" \
    || die "pacman failed — if it was a 404 your package database is stale: run 'sudo pacman -Syu' and retry."
ok "Packages installed"

# ── 2. Get the repo ──────────────────────────────────────────
step "Fetching dotfiles"
SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/fish/config.fish" ]]; then
    SRC="$SCRIPT_DIR"
    info "Using local repo at $SRC"
elif [[ -d "$CLONE_DIR/.git" ]]; then
    info "Updating $CLONE_DIR"
    git -C "$CLONE_DIR" pull --ff-only || die "git pull failed in $CLONE_DIR — resolve it manually and retry."
    SRC="$CLONE_DIR"
elif [[ -e "$CLONE_DIR" ]]; then
    die "$CLONE_DIR exists but isn't a git checkout — move it aside and retry."
else
    info "Cloning $REPO_URL"
    git clone --depth 1 "$REPO_URL" "$CLONE_DIR"
    SRC="$CLONE_DIR"
fi

# ── 3. Back up + deploy ──────────────────────────────────────
# Copy (not move) the backup, then overwrite only the files this
# repo owns. fish_variables (universal vars), fisher plugins and
# the kitty theme all survive a re-run.
step "Backing up existing configs"
STAMP="$(date +%Y%m%d-%H%M%S)"
for d in kitty fish fastfetch; do
    if [[ -e "$HOME/.config/$d" ]]; then
        cp -a "$HOME/.config/$d" "$HOME/.config/$d.bak-$STAMP"
        info "~/.config/$d → ~/.config/$d.bak-$STAMP"
    fi
done
if [[ -e "$HOME/.config/starship.toml" ]]; then
    cp -a "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.bak-$STAMP"
    info "~/.config/starship.toml → ~/.config/starship.toml.bak-$STAMP"
fi
ok "Backups complete"

step "Deploying configs"
mkdir -p "$HOME/.config/kitty"
cp "$SRC/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
touch "$HOME/.config/kitty/themes.conf"
# Leftovers from the old per-theme installs
rm -f "$HOME/.config/kitty/theme.conf" "$HOME/.config/kitty/os.conf"
ok "kitty"

mkdir -p "$HOME/.config/fish"
cp -r "$SRC/fish/." "$HOME/.config/fish/"
# Leftovers from the old per-theme installs; fish_frozen_theme.fish
# (fish ≥4.3 migration) would load after colors.fish and override it
rm -f "$HOME/.config/fish/conf.d/00-theme.fish" \
      "$HOME/.config/fish/conf.d/fish_frozen_theme.fish" \
      "$HOME/.config/fish/themes/graphite-emerald.fish" \
      "$HOME/.config/fish/themes/catppuccin-mocha.fish"
ok "fish"

# Only replace a starship.toml we deployed (it has our palette);
# a hand-made one is left alone
if [[ ! -e "$HOME/.config/starship.toml" ]] || grep -q '^\[palettes\.dotfiles\]' "$HOME/.config/starship.toml"; then
    cp "$SRC/starship/starship.toml" "$HOME/.config/starship.toml"
    ok "starship"
else
    warn "Kept your own ~/.config/starship.toml — prompt colors won't follow theme-pick"
fi

if [[ $DO_FASTFETCH -eq 1 ]]; then
    mkdir -p "$HOME/.config/fastfetch"
    cp "$SRC/fastfetch/config.jsonc.in" "$SRC/fastfetch/logo.svg.in" "$HOME/.config/fastfetch/"
    ok "fastfetch"
fi

fc-cache -f >/dev/null
ok "Font cache refreshed"

# ── 4. fisher + plugins ──────────────────────────────────────
# fish_plugins no longer lists tide, so `fisher update` also
# uninstalls it on machines upgraded from the old setup.
if [[ $DO_PLUGINS -eq 1 ]]; then
    step "Installing fisher plugins"
    # </dev/null so fish can't swallow the rest of this script under curl|bash
    fish -c 'fisher update' </dev/null \
        || die "fisher failed — retry with: fish -c 'fisher update'"
    ok "Plugins installed"
fi

# ── 5. Colors ────────────────────────────────────────────────
step "Colors"
# Values go through the environment so fish never parses them as its own options
export DOTFILES_THEME="$THEME" DOTFILES_ACCENT="$ACCENT"
if [[ $DO_DMS -eq 1 ]]; then
    fish -c 'set -l a; test -n "$DOTFILES_ACCENT"; and set a --accent $DOTFILES_ACCENT
             theme-pick --dms $a' </dev/null \
        || warn "theme-pick --dms failed — is the kitty template enabled in DMS? Re-run anytime with: theme-pick --dms"
elif [[ $INTERACTIVE -eq 1 || -n "$THEME" ]]; then
    [[ -z "$THEME$ACCENT" ]] && info "Opening kitty's theme browser — arrows to browse, Enter to pick, Esc to keep the current theme."
    PICK_IN=/dev/null
    [[ $INTERACTIVE -eq 1 ]] && PICK_IN=/dev/tty
    fish -c 'set -l a; test -n "$DOTFILES_ACCENT"; and set a --accent $DOTFILES_ACCENT
             theme-pick $a $DOTFILES_THEME' <"$PICK_IN" \
        || warn "theme-pick failed — re-run anytime with: theme-pick"
else
    # -y without --theme: keep kitty's current theme (or DMS mode) and
    # the current accent unless --accent was given
    fish -c 'test -n "$DOTFILES_ACCENT"; and set -U dotfiles_accent $DOTFILES_ACCENT
             set -q dotfiles_accent[1]; or set -U dotfiles_accent green
             dotfiles-apply-colors' </dev/null
fi
ok "Colors applied"

# ── 6. Default shell ─────────────────────────────────────────
if [[ $DO_SHELL_CHANGE -eq 1 ]]; then
    step "Setting default shell"
    FISH_PATH="$(command -v fish)"
    grep -qx "$FISH_PATH" /etc/shells || echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
    if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$FISH_PATH" ]]; then
        chsh -s "$FISH_PATH" </dev/tty || warn "chsh failed — run manually: chsh -s $FISH_PATH"
    fi
    ok "Default shell: fish"
fi

# ── Done ─────────────────────────────────────────────────────
printf '\n%s%s✓ All done.%s Open a new kitty window to see everything.\n' "$C_BOLD" "$C_ACC" "$C_RESET"
printf '  Backups:          %s~/.config/{kitty,fish,fastfetch}.bak-%s%s\n' "$C_DIM" "$STAMP" "$C_RESET"
printf '  Change colors:    %stheme-pick%s\n' "$C_DIM" "$C_RESET"
printf '  Change prompt:    %s~/.config/starship.toml%s\n\n' "$C_DIM" "$C_RESET"
