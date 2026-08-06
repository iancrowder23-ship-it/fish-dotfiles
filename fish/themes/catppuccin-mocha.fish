# ══════════════════════════════════════════════════════════════
#  Theme: Catppuccin Mocha — deployed as conf.d/00-theme.fish
#  Original theme, restored.
# ══════════════════════════════════════════════════════════════

# ── Syntax highlighting ─────────────────────────────────────────
set -g fish_color_command          CBA6F7   # commands       → mauve
set -g fish_color_param            FAB387   # arguments      → peach
set -g fish_color_option           F97316   # flags/options  → orange
set -g fish_color_keyword          F38BA8   # keywords       → red/pink
set -g fish_color_builtin          89B4FA   # builtins       → blue
set -g fish_color_operator         94E2D5   # operators      → teal
set -g fish_color_redirection      F9E2AF   # redirects      → yellow
set -g fish_color_end              A6E3A1   # semicolons     → green
set -g fish_color_error            F38BA8   # errors         → red
set -g fish_color_comment          6C7086   # comments       → surface2
set -g fish_color_quote            A6E3A1   # strings        → green
set -g fish_color_autosuggestion   585B70   # ghost text     → surface0
set -g fish_color_search_match     --background=6D28D9
set -g fish_color_selection        --background=6D28D9
set -g fish_pager_color_prefix     CBA6F7
set -g fish_pager_color_completion FAB387
set -g fish_pager_color_description 6C7086
set -g fish_pager_color_progress   CBA6F7

# ── Git prompt colors ────────────────────────────────────────────
set -g __fish_git_prompt_color_branch          brmagenta
set -g __fish_git_prompt_color_upstream_ahead  brgreen
set -g __fish_git_prompt_color_upstream_behind brred
set -g __fish_git_prompt_color_dirty           bryellow
set -g __fish_git_prompt_color_staged          brgreen
set -g __fish_git_prompt_color_invalidstate    brred
set -g __fish_git_prompt_color_untrackedfiles  brcyan

# ── Greeting gradient (purple → orange) ──────────────────────────
set -Ux fish_greeting_gradient CBA6F7 B794F4 A78BFA 9333EA 7C3AED 8B5CF6 A78BFA C084FC E879F9 FAB387 FB923C F97316 EA580C F97316 FB923C FAB387
set -Ux fish_greeting_accent   6D28D9
