# ══════════════════════════════════════════════════════════════
#  Theme: Graphite Emerald — deployed as conf.d/00-theme.fish
#  Modern dark-graphite base, purple/peach accents (carried over
#  from the original look), emerald green used sparingly.
#  Loads before conf.d/animations.fish and config.fish.
# ══════════════════════════════════════════════════════════════

# ── Syntax highlighting ─────────────────────────────────────────
set -g fish_color_command          CBA6F7   # commands       → mauve/purple
set -g fish_color_param            E4E6EB   # arguments      → light gray
set -g fish_color_option           F5A97F   # flags/options  → peach
set -g fish_color_keyword          89B4FA   # keywords       → blue
set -g fish_color_builtin          34D399   # builtins       → emerald
set -g fish_color_operator         7DD3C0   # operators      → teal
set -g fish_color_redirection      F5A97F   # redirects      → peach
set -g fish_color_end              9DA1AB   # semicolons     → muted gray
set -g fish_color_error            F38BA8   # errors         → red
set -g fish_color_comment          565A66   # comments       → dim gray
set -g fish_color_quote            34D399   # strings        → emerald
set -g fish_color_autosuggestion   565A66   # ghost text     → dim gray
set -g fish_color_search_match     --background=3A3D45
set -g fish_color_selection        --background=CBA6F7
set -g fish_pager_color_prefix     CBA6F7
set -g fish_pager_color_completion E4E6EB
set -g fish_pager_color_description 565A66
set -g fish_pager_color_progress   34D399

# ── Git prompt colors ────────────────────────────────────────────
set -g __fish_git_prompt_color_branch          brmagenta
set -g __fish_git_prompt_color_upstream_ahead  brgreen
set -g __fish_git_prompt_color_upstream_behind brred
set -g __fish_git_prompt_color_dirty           F5A97F
set -g __fish_git_prompt_color_staged          brgreen
set -g __fish_git_prompt_color_invalidstate    brred
set -g __fish_git_prompt_color_untrackedfiles  bryellow

# ── Greeting gradient (purple → peach → emerald) ─────────────────
set -Ux fish_greeting_gradient CBA6F7 B794F4 A78BFA 9683F0 89B4FA 7DD3C0 62D9AA 4ADE80 34D399 4ADE80 62D9AA 7DD3C0 89B4FA 9683F0 A78BFA CBA6F7
set -Ux fish_greeting_accent   9683F0
