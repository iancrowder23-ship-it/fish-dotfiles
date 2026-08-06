#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════
#  fish-dotfiles — interactive Arch Linux installer
#
#  A guided walkthrough: pick a color theme, choose optional
#  components, install packages, deploy configs, install fisher
#  plugins, then hand you off to Tide's own official interactive
#  `tide configure` wizard so YOU pick prompt layout/style/icons/
#  separators exactly how you want them. This script never
#  hand-writes tide_* layout settings — it only supplies COLORS
#  (kitty, fish syntax/git highlighting, fastfetch) per theme.
#
#  Usage (one command, full interactive walkthrough):
#    curl -fsSL https://raw.githubusercontent.com/iancrowder23-ship-it/fish-dotfiles/main/install.sh | bash
#
#  Non-interactive / scripted (skips the walkthrough):
#    ./install.sh --theme graphite-emerald --yes
#    ./install.sh --theme catppuccin-mocha --no-fastfetch --no-shell-change
#    ./install.sh --no-tide-wizard
#
#  Flags:
#    -t, --theme <name>     graphite-emerald (default) | catppuccin-mocha
#    -y, --yes              accept all defaults, skip the interactive walkthrough
#        --no-fastfetch     skip installing/deploying fastfetch
#        --no-shell-change  don't chsh to fish
#        --no-plugins       skip fisher + plugin install
#        --no-tide-wizard   skip the interactive `tide configure` wizard
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
task_start() { printf '  %s%s%s %s%s...%s\n' "$C_GRAY" "$GLYPH_DOT" "$C_RESET" "$C_DIM" "$*" "$C_RESET"; }

ask_yn() {
    # ask_yn "question" default(y|n) -> sets REPLY_YN=0/1
    local q="$1" def="${2:-y}" ans suffix
    [[ "$def" == "y" ]] && suffix="[Y/n]" || suffix="[y/N]"
    printf '  %s%s%s %s %s%s%s ' "$C_PURPLE" "$GLYPH_ARROW" "$C_RESET" "$q" "$C_DIM" "$suffix" "$C_RESET"
    read -r ans </dev/tty || ans=""
    ans="${ans:-$def}"
    if [[ "$ans" =~ ^[Yy] ]]; then REPLY_YN=1; else REPLY_YN=0; fi
}

# ── Available themes (name → description) ─────────────────────
THEME_NAMES=(graphite-emerald catppuccin-mocha)
theme_desc() {
    case "$1" in
        graphite-emerald) echo "Monochrome graphite base, emerald green accent (modern, muted)" ;;
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
DO_TIDE_WIZARD=1
WALKTHROUGH=1

print_help() {
    sed -n '2,29p' "$0" | sed 's/^# \{0,1\}//'
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--theme) THEME="${2:-}"; shift 2 ;;
        -y|--yes) ASSUME_YES=1; WALKTHROUGH=0; shift ;;
        --no-fastfetch) DO_FASTFETCH=0; shift ;;
        --no-shell-change) DO_SHELL_CHANGE=0; shift ;;
        --no-plugins) DO_PLUGINS=0; shift ;;
        --no-tide-wizard) DO_TIDE_WIZARD=0; shift ;;
        --list-themes) list_themes; exit 0 ;;
        -h|--help) print_help; exit 0 ;;
        *) die "Unknown option: $1 (see --help)" ;;
    esac
done

# Non-interactive terminals (piped, CI, etc.) can't run a walkthrough
[[ -t 0 ]] || WALKTHROUGH=0

banner

# ── 0. Sanity checks ─────────────────────────────────────────
[[ "$(uname -s)" == "Linux" ]] || die "This script is for Arch Linux. On macOS, copy the configs manually (see README)."
command -v pacman >/dev/null 2>&1 || die "pacman not found — this script targets Arch Linux."
[[ $EUID -ne 0 ]] || die "Run as your normal user, not root (sudo is used where needed)."

# ── 0b. Interactive walkthrough ────────────────────────────────
if [[ $WALKTHROUGH -eq 1 ]]; then
    printf '%sThis walkthrough will:%s\n' "$C_BOLD" "$C_RESET"
    printf '  %s1)%s let you pick a color theme\n' "$C_DIM" "$C_RESET"
    printf '  %s2)%s let you choose optional components (fastfetch, default shell)\n' "$C_DIM" "$C_RESET"
    printf '  %s3)%s install everything\n' "$C_DIM" "$C_RESET"
    printf '  %s4)%s hand you off to Tide'"'"'s own interactive prompt wizard so you can\n' "$C_DIM" "$C_RESET"
    printf '     %scustomize the prompt segments/style/separators/icons yourself%s\n' "$C_DIM" "$C_RESET"
    printf '\n'
fi

if [[ -z "$THEME" ]]; then
    if [[ $WALKTHROUGH -eq 1 ]]; then
        printf '%sStep 1 — Choose a color theme:%s\n' "$C_BOLD" "$C_RESET"
        i=1
        for t in "${THEME_NAMES[@]}"; do
            printf '  %s%d)%s %s%s%s  %s%s%s\n' "$C_PURPLE" "$i" "$C_RESET" "$C_BOLD" "$t" "$C_RESET" "$C_DIM" "$(theme_desc "$t")" "$C_RESET"
            i=$((i+1))
        done
        printf '%sEnter choice [1]:%s ' "$C_GRAY" "$C_RESET"
        read -r choice </dev/tty || choice=""
        choice="${choice:-1}"
        THEME="${THEME_NAMES[$((choice-1))]:-graphite-emerald}"
    else
        THEME="graphite-emerald"
    fi
fi

if [[ ! " ${THEME_NAMES[*]} " =~ " ${THEME} " ]]; then
    die "Unknown theme '$THEME'. Run with --list-themes to see options."
fi
ok "Theme: ${C_BOLD}${THEME}${C_RESET} — $(theme_desc "$THEME")"

if [[ $WALKTHROUGH -eq 1 ]]; then
    printf '\n%sStep 2 — Optional components:%s\n' "$C_BOLD" "$C_RESET"

    ask_yn "Install fastfetch and run it on every new shell?" y
    DO_FASTFETCH=$REPLY_YN

    ask_yn "Install fisher + plugins (tide, autopair, done, puffer-fish)?" y
    DO_PLUGINS=$REPLY_YN

    if [[ $DO_PLUGINS -eq 1 ]]; then
        ask_yn "Launch Tide's interactive 'tide configure' wizard after install (recommended — this is how you customize the prompt)?" y
        DO_TIDE_WIZARD=$REPLY_YN
    else
        DO_TIDE_WIZARD=0
    fi

    ask_yn "Set fish as your default login shell?" y
    DO_SHELL_CHANGE=$REPLY_YN
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
    ok "Plugins installed (tide, autopair, done, puffer-fish)"

    # ── 7. Tide's own interactive configure wizard ───────────
    # We deliberately do NOT hand-write tide_* prompt layout
    # settings. Tide ships an official guided wizard that walks
    # you through prompt style, character set, segment order,
    # spacing, transient prompt, and more — that's the real
    # customization system, so we launch it here.
    if [[ $DO_TIDE_WIZARD -eq 1 ]]; then
        step "Launching Tide's interactive prompt wizard"
        info "Answer the on-screen questions to build your prompt exactly how you want it."
        info "(Colors are already set by the '$THEME' theme — this wizard controls layout/style.)"
        printf '\n'
        fish -c 'tide configure' </dev/tty || warn "tide configure exited early — re-run anytime with: fish -c 'tide configure'"
    else
        warn "Skipped the tide wizard — run it anytime with: fish -c 'tide configure'"
    fi
else
    warn "Skipping fisher/plugins (per your choice) — no prompt engine installed"
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
printf '  Re-run the prompt wizard anytime: %sfish -c '"'"'tide configure'"'"'%s\n' "$C_DIM" "$C_RESET"
printf '  Switch color themes anytime: %s./install.sh --theme <name> --no-plugins --no-shell-change%s\n\n' "$C_DIM" "$C_RESET"
