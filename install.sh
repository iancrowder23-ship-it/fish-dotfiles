#!/usr/bin/env bash
# ════════════════════════════════════════════════════════════════
#  fish-dotfiles — one-command Arch Linux setup
#
#  Installs kitty + fish + fonts + tools, deploys configs,
#  installs fisher plugins, restores the tide prompt theme,
#  and sets fish as the default shell.
#
#  Usage (one command):
#    curl -fsSL https://raw.githubusercontent.com/iancrowder23-ship-it/fish-dotfiles/main/install.sh | bash
#
#  Or from a local clone:
#    ./install.sh
# ════════════════════════════════════════════════════════════════
set -euo pipefail

REPO_URL="https://github.com/iancrowder23-ship-it/fish-dotfiles.git"
CLONE_DIR="$HOME/.local/share/fish-dotfiles"

info()  { printf '\033[1;35m==>\033[0m %s\n' "$*"; }
ok()    { printf '\033[1;32m ✓ \033[0m %s\n' "$*"; }
die()   { printf '\033[1;31m ✗ \033[0m %s\n' "$*" >&2; exit 1; }

# ── 0. Sanity checks ─────────────────────────────────────────
[[ "$(uname -s)" == "Linux" ]] || die "This script is for Arch Linux. On macOS, copy the configs manually (see README)."
command -v pacman >/dev/null 2>&1 || die "pacman not found — this script targets Arch Linux."
[[ $EUID -ne 0 ]] || die "Run as your normal user, not root (sudo is used where needed)."

# ── 1. Install packages ──────────────────────────────────────
info "Installing packages (kitty, fish, fonts, tools)..."
sudo pacman -S --needed --noconfirm \
    kitty \
    fish \
    git \
    curl \
    eza \
    bind \
    libnotify \
    fastfetch \
    ttf-jetbrains-mono-nerd \
    noto-fonts-emoji
ok "Packages installed"
# bind        → provides `dig` (used by the myip alias)
# libnotify   → desktop notifications for the `done` fish plugin
# fastfetch   → system info banner shown on every new shell
# ttf-jetbrains-mono-nerd → the font kitty.conf uses

# ── 2. Get the repo ──────────────────────────────────────────
# If running from a local clone, use it; otherwise clone fresh.
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

# ── 3. Back up any existing configs ──────────────────────────
STAMP="$(date +%Y%m%d-%H%M%S)"
for d in kitty fish; do
    if [[ -e "$HOME/.config/$d" ]]; then
        info "Backing up existing ~/.config/$d → ~/.config/$d.bak-$STAMP"
        mv "$HOME/.config/$d" "$HOME/.config/$d.bak-$STAMP"
    fi
done

# ── 4. Deploy configs ────────────────────────────────────────
info "Deploying kitty config..."
mkdir -p "$HOME/.config/kitty"
cp "$SRC/kitty/kitty.conf"    "$HOME/.config/kitty/kitty.conf"
cp "$SRC/kitty/os-linux.conf" "$HOME/.config/kitty/os.conf"
ok "kitty config in place"

info "Deploying fish config..."
mkdir -p "$HOME/.config/fish"
cp -r "$SRC/fish/." "$HOME/.config/fish/"
ok "fish config in place"

info "Deploying fastfetch config..."
mkdir -p "$HOME/.config/fastfetch"
cp "$SRC/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
ok "fastfetch config in place"

# ── 5. Refresh font cache ────────────────────────────────────
info "Refreshing font cache..."
fc-cache -f >/dev/null
ok "Font cache updated"

# ── 6. Install fisher + plugins (tide, autopair, done, puffer)─
# Robust non-interactive method: drop fisher.fish into the autoload
# dir first, THEN run `fisher update` (the pipe-to-source bootstrap
# is unreliable in scripts — see fisher issues #639 / #644).
info "Installing fisher and plugins..."
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

# ── 7. Restore tide prompt theme (exact export from macOS) ───
info "Applying tide prompt configuration..."
fish "$SRC/scripts/tide-config.fish" </dev/null
ok "Tide theme applied"

# ── 8. Set fish as default shell ─────────────────────────────
FISH_PATH="$(command -v fish)"
if ! grep -qx "$FISH_PATH" /etc/shells; then
    echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "${SHELL:-}" != "$FISH_PATH" ]]; then
    info "Setting fish as default shell (you may be asked for your password)..."
    # read password from the terminal even when run via `curl | bash`
    chsh -s "$FISH_PATH" </dev/tty || info "chsh failed — run manually: chsh -s $FISH_PATH"
fi
ok "Default shell: fish"

printf '\n\033[1;32m  All done!\033[0m Log out/in (or just launch kitty) to enjoy the full setup.\n'
printf '  Backups of any previous configs: ~/.config/{kitty,fish}.bak-%s\n' "$STAMP"
