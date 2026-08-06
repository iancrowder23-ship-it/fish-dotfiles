#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════
#  fish-dotfiles — one-command Arch Linux installer
#
#  Installs kitty + fish + fonts + tools, deploys configs,
#  installs fisher plugins, applies your chosen tide theme,
#  optionally sets up fastfetch, and sets fish as the shell.
#
#  Usage (one command, interactive menu):
#    curl -fsSL https://raw.githubusercontent.com/iancrowder23-ship-it/fish-dotfiles/main/install.sh | bash
#
#  Non-interactive / scripted:
#    ./install.sh --theme graphite-emerald --yes
#    ./install.sh --theme catppuccin-mocha --no-fastfetch --no-shell-change
#
#  Flags:
#    -t, --theme <name>     graphite-emerald (default) | catppuccin-mocha
#    -y, --yes              accept all defaults, skip prompts
#        --no-fastfetch     skip installing/deploying fastfetch
#        --no-shell-change  don't chsh to fish
#        --no-plugins       skip fisher + plugin install
#        --list-themes      print available themes and exit
#    -h, --help             show this help and exit
# ════════════════════════════════════════════════════════════════
set -euo pipefail

REPO_URL="https://github.com/iancrowder23-ship-it/fish-dotfiles.git"
CLONE_DIR="$HOME/.local/share/fish-dotfiles"

# ── Colors & symbols ─────────────────────────────────────────
if [[ -t 1 ]]; then
    C_RESET=$'\033[0m';   C_BOLD=$'\033[1m';    C_DIM=$'\033[2m'
    C_PURPLE=$'\033[38;5;140m'; C_PEACH=$'\033[38;5;216m'
    C_GREEN=$'\033[38;5;115m';  C_RED=$'\033[38;5;210m'
    C_BLUE=$'\033[38;5;110m';   C_GRAY=$'\033[38;5;244m'
else
    C_RESET=""; C_BOLD=""; C_DIM=""; C_PURPLE=""; C_PEACH=""
    C_GREEN=""; C_RED=""; C_BLUE=""; C_GRAY=""
fi

GLYPH_ARROW="❯"
GLYPH_OK="✓"
GLYPH_ERR="✗"
GLYPH_WARN="!"
GLYPH_DOT="·"

banner() {
    printf '\n%s%s' "$C_PURPLE" "$C_BOLD"
    cat <<'EOF'
   ╭──────────────────────────────────────────╮
   │   fish-dotfiles ── kitty + fish setup     │
   ╰──────────────────────────────────────────╯
EOF
    printf '%s\n' "$C_RESET"
}

step()  { printf '\n%s%s %s%s%s %s\n' "$C_BOLD" "$C_PURPLE" "$GLYPH_ARROW" "$C_RESET" "$C_BOLD" "$*$C_RESET"; }
info()  { printf '  %s%s%s %s\n' "$C_BLUE" "$GLYPH_DOT" "$C_RESET" "$*"; }
ok()    { printf '  %s%s%s %s\n' "$C_GREEN" "$GLYPH_OK" "$C_RESET" "$*"; }
warn()  { printf '  %s%s%s %s\n' "$C_PEACH" "$GLYPH_WARN" "$C_RESET" "$*"; }
die()   { printf '  %s%s%s %s\n' "$C_RED" "$GLYPH_ERR" "$C_RESET" "$*" >&2; exit 1; }

# Simple spinner-free progress marker for long steps
task_start() { printf '  %s%s%s %s%s...%s\n' "$C_GRAY" "$GLYPH_DOT" "$C_RESET" "$C_DIM" "$*" "$C_RESET"; }

# ── Available themes (name → description) ─────────────────────
THEME_NAMES=(graphite-emerald catppuccin-mocha)
theme_desc() {
    case "$1" in
        graphite-emerald) echo "Modern graphite base, purple/peach accents, emerald green highlights" ;;
        catppuccin-mocha) echo "The original — warm purple/peach Catppuccin Mocha" ;;
        *) echo "" ;;
    esac
}

list_themes() {
    printf '\n%sAvailable themes:%s\n' "$C_BOLD" "$C_RESET"
    for t in "${THEME_NAMES[@]}"; do
        printf '  %s%s%s  %s%s%s\n' "$C_PURPLE" "$t" "$C_RESET" "$C_DIM" "$(theme_desc "$t")" "$C_RESET"
    done
    printf '\n'
}

# ── Parse args ──────────────────────────────────────────────
THEME=""
ASSUME_YES=0
DO_FASTFETCH=1
DO_SHELL_CHANGE=1
DO_PLUGINS=1

print_help() {
    sed -n '2,24p' "$0" | sed 's/^# \{0,1\}//'
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--theme) THEME="${2:-}"; shift 2 ;;
        -y|--yes) ASSUME_YES=1; shift ;;
        --no-fastfetch) DO_FASTFETCH=0; shift ;;
        --no-shell-change) DO_SHELL_CHANGE=0; shift ;;
        --no-plugins) DO_PLUGINS=0; shift ;;
        --list-themes) list_themes; exit 0 ;;
        -h|--help) print_help; exit 0 ;;
        *) die "Unknown option: $1 (see --help)" ;;
    esac
done

banner

# ── 0. Sanity checks ─────────────────────────────────────────
[[ "$(uname -s)" == "Linux" ]] || die "This script is for Arch Linux. On macOS, copy the configs manually (see README)."
command -v pacman >/dev/null 2>&1 || die "pacman not found — this script targets Arch Linux."
[[ $EUID -ne 0 ]] || die "Run as your normal user, not root (sudo is used where needed)."

# ── 0b. Interactive prompts (skipped with --yes or when flags given) ──
if [[ -z "$THEME" ]]; then
    if [[ $ASSUME_YES -eq 1 || ! -t 0 ]]; then
        THEME="graphite-emerald"
    else
        printf '%sChoose a color theme:%s\n' "$C_BOLD" "$C_RESET"
        i=1
        for t in "${THEME_NAMES[@]}"; do
            printf '  %s%d)%s %s%s%s  %s%s%s\n' "$C_PURPLE" "$i" "$C_RESET" "$C_BOLD" "$t" "$C_RESET" "$C_DIM" "$(theme_desc "$t")" "$C_RESET"
            i=$((i+1))
        done
        printf '%sEnter choice [1]:%s ' "$C_GRAY" "$C_RESET"
        read -r choice </dev/tty || choice=""
        choice="${choice:-1}"
        THEME="${THEME_NAMES[$((choice-1))]:-graphite-emerald}"
    fi
fi

if [[ ! " ${THEME_NAMES[*]} " =~ " ${THEME} " ]]; then
    die "Unknown theme '$THEME'. Run with --list-themes to see options."
fi
ok "Theme: ${C_BOLD}${THEME}${C_RESET} — $(theme_desc "$THEME")"

if [[ $ASSUME_YES -eq 0 && -t 0 ]]; then
    printf '%sInstall fastfetch + run it on shell startup? [Y/n]:%s ' "$C_GRAY" "$C_RESET"
    read -r ans </dev/tty || ans="y"
    [[ "$ans" =~ ^[Nn] ]] && DO_FASTFETCH=0

    printf '%sSet fish as your default shell? [Y/n]:%s ' "$C_GRAY" "$C_RESET"
    read -r ans </dev/tty || ans="y"
    [[ "$ans" =~ ^[Nn] ]] && DO_SHELL_CHANGE=0
fi

# ── 1. Install packages ──────────────────────────────────────
step "Installing packages"
PKGS=(kitty fish git curl eza bind libnotify ttf-jetbrains-mono-nerd noto-fonts-emoji)
[[ $DO_FASTFETCH -eq 1 ]] && PKGS+=(fastfetch)
task_start "pacman -S ${PKGS[*]}"
sudo pacman -S --needed --noconfirm "${PKGS[@]}"
ok "Packages installed"
# bind        → provides `dig` (used by the myip alias)
# libnotify   → desktop notifications for the `done` fish plugin
# fastfetch   → system info banner shown on every new shell (optional)
# ttf-jetbrains-mono-nerd → the font kitty.conf uses

# ── 2. Get the repo ──────────────────────────────────────────
step "Fetching dotfiles"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-/dev/null}")" 2>/dev/null && pwd || true)"
if [[ -n "$SCRIPT_DIR" && -f "$SCRIPT_DIR/fish/config.fish" ]]; then
    SRC="$SCRIPT_DIR"
    info "Using local repo at $SRC"
else
    info "Cloning $REPO_URL ..."
    rm -rf "$CLONE_DIR"
    git clone --depth 1 "$REPO_URL" "$CLONE_DIR"
    SRC="$CLONE_DIR"
fi

[[ -f "$SRC/kitty/themes/$THEME.conf" ]] || die "Theme files missing for '$THEME' — repo may be out of date."

# ── 3. Back up any existing configs ──────────────────────────
step "Backing up existing configs"
STAMP="$(date +%Y%m%d-%H%M%S)"
for d in kitty fish fastfetch; do
    if [[ -e "$HOME/.config/$d" ]]; then
        info "~/.config/$d → ~/.config/$d.bak-$STAMP"
        mv "$HOME/.config/$d" "$HOME/.config/$d.bak-$STAMP"
    fi
done
ok "Backups complete"

# ── 4. Deploy configs ────────────────────────────────────────
step "Deploying configs"

info "kitty (theme: $THEME)"
mkdir -p "$HOME/.config/kitty"
cp "$SRC/kitty/kitty.conf"        "$HOME/.config/kitty/kitty.conf"
cp "$SRC/kitty/os-linux.conf"     "$HOME/.config/kitty/os.conf"
cp "$SRC/kitty/themes/$THEME.conf" "$HOME/.config/kitty/theme.conf"
ok "kitty config in place"

info "fish (theme: $THEME)"
mkdir -p "$HOME/.config/fish/conf.d"
cp -r "$SRC/fish/." "$HOME/.config/fish/"
cp "$SRC/fish/themes/$THEME.fish" "$HOME/.config/fish/conf.d/00-theme.fish"
ok "fish config in place"

if [[ $DO_FASTFETCH -eq 1 ]]; then
    info "fastfetch (theme: $THEME)"
    mkdir -p "$HOME/.config/fastfetch"
    cp "$SRC/fastfetch/$THEME.jsonc" "$HOME/.config/fastfetch/config.jsonc"
    ok "fastfetch config in place"
else
    warn "Skipping fastfetch (per your choice) — greeting will run without it"
fi

# ── 5. Refresh font cache ────────────────────────────────────
step "Refreshing font cache"
fc-cache -f >/dev/null
ok "Font cache updated"

# ── 6. Install fisher + plugins (tide, autopair, done, puffer)─
if [[ $DO_PLUGINS -eq 1 ]]; then
    step "Installing fisher and plugins"
    mkdir -p "$HOME/.config/fish/functions" "$HOME/.config/fish/completions"
    curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
        -o "$HOME/.config/fish/functions/fisher.fish" \
        || die "Could not download fisher.fish — check network access to raw.githubusercontent.com"
    curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/completions/fisher.fish \
        -o "$HOME/.config/fish/completions/fisher.fish" || true
    # </dev/null so fish can't swallow the rest of this script when piped via curl|bash
    if ! fish -c 'fisher update' </dev/null; then
        die "fisher update failed — see the error above, then retry with: fish -c 'fisher update'"
    fi
    ok "Plugins installed"

    # ── 7. Apply tide prompt theme ───────────────────────────
    step "Applying tide prompt ($THEME)"
    fish "$SRC/scripts/tide/$THEME.fish" </dev/null
    ok "Tide theme applied"
else
    warn "Skipping fisher/plugins (per your choice) — tide prompt theme not applied"
fi

# ── 8. Set fish as default shell ─────────────────────────────
if [[ $DO_SHELL_CHANGE -eq 1 ]]; then
    step "Setting default shell"
    FISH_PATH="$(command -v fish)"
    if ! grep -qx "$FISH_PATH" /etc/shells; then
        echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi
    if [[ "${SHELL:-}" != "$FISH_PATH" ]]; then
        info "Changing shell to $FISH_PATH (you may be asked for your password)..."
        chsh -s "$FISH_PATH" </dev/tty || warn "chsh failed — run manually: chsh -s $FISH_PATH"
    fi
    ok "Default shell: fish"
else
    warn "Skipping shell change (per your choice)"
fi

# ── Done ──────────────────────────────────────────────────────
printf '\n%s%s╭──────────────────────────────────────────╮%s\n' "$C_BOLD" "$C_GREEN" "$C_RESET"
printf '%s%s│  %s All done! Theme: %-18s │%s\n' "$C_BOLD" "$C_GREEN" "$GLYPH_OK" "$THEME" "$C_RESET"
printf '%s%s╰──────────────────────────────────────────╯%s\n\n' "$C_BOLD" "$C_GREEN" "$C_RESET"
printf '  Log out/in (or just launch kitty) to enjoy the full setup.\n'
printf '  Backups of any previous configs: %s~/.config/{kitty,fish,fastfetch}.bak-%s%s\n' "$C_DIM" "$STAMP" "$C_RESET"
printf '  Switch themes anytime: %s./install.sh --theme <name> --no-plugins --no-shell-change%s\n\n' "$C_DIM" "$C_RESET"
