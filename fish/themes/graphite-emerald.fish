# ══════════════════════════════════════════════════════════════
#  Theme: Graphite Emerald — deployed as conf.d/00-theme.fish
#  Monochrome-graphite base (black → gray → white), emerald green
#  as the recurring accent. Purple/peach dialed back to rare
#  secondary touches instead of dominant colors.
#  Loads before conf.d/animations.fish and config.fish.
# ══════════════════════════════════════════════════════════════

# ── Syntax highlighting ─────────────────────────────────────────
set -g fish_color_command          34D399   # commands       → emerald
set -g fish_color_param            D6D9DE   # arguments      → light gray
set -g fish_color_option           8A8F99   # flags/options  → mid gray
set -g fish_color_keyword          C7CAD1   # keywords       → near-white gray
set -g fish_color_builtin          7DD3C0   # builtins       → teal-green
set -g fish_color_operator         8A8F99   # operators      → mid gray
set -g fish_color_redirection      9BA0AB   # redirects      → gray
set -g fish_color_end              565A66   # semicolons     → dim gray
set -g fish_color_error            E5789A   # errors         → muted red
set -g fish_color_comment          4A4D55   # comments       → dim gray
set -g fish_color_quote            34D399   # strings        → emerald
set -g fish_color_autosuggestion   4A4D55   # ghost text     → dim gray
set -g fish_color_search_match     --background=33363D
set -g fish_color_selection        --background=33363D
set -g fish_pager_color_prefix     34D399
set -g fish_pager_color_completion D6D9DE
set -g fish_pager_color_description 565A66
set -g fish_pager_color_progress   34D399

# ── Git prompt colors ────────────────────────────────────────────
set -g __fish_git_prompt_color_branch          brgreen
set -g __fish_git_prompt_color_upstream_ahead  brgreen
set -g __fish_git_prompt_color_upstream_behind brred
set -g __fish_git_prompt_color_dirty           white
set -g __fish_git_prompt_color_staged          brgreen
set -g __fish_git_prompt_color_invalidstate    brred
set -g __fish_git_prompt_color_untrackedfiles  white

# ── Greeting gradient (gray → emerald → gray, monochrome-led) ────
set -Ux fish_greeting_gradient C7CAD1 A9AEB8 8A8F99 6E9C8C 55B39C 34D399 55B39C 6E9C8C 8A8F99 A9AEB8 C7CAD1
set -Ux fish_greeting_accent   565A66
