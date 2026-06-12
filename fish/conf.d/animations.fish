# ══════════════════════════════════════════════════════════════
#  animations.fish — loaded at every fish startup via conf.d
#  Event handlers MUST live here, not in functions/, to register
# ══════════════════════════════════════════════════════════════

# ── Default cursor: blinking beam ─────────────────────────────
printf '\e[5 q'

# ── On Enter: cursor morphs beam → underline → block ──────────
# The visual "click" feeling — cursor locks into a block while
# the command runs, exactly like popular Arch fish dotfiles
function _cursor_preexec --on-event fish_preexec
    printf '\e[6 q'   # steady beam
    sleep 0.04
    printf '\e[4 q'   # steady underline
    sleep 0.04
    printf '\e[2 q'   # steady block — command is running
end

# ── After command: flash exit status then restore cursor ───────
function _cursor_postexec --on-event fish_postexec
    set -l code $status  # capture immediately — only $argv[1] (cmd text) is passed

    if test $code -eq 0
        printf '%s ✓%s\n' (set_color -o brgreen) (set_color normal)
    else
        printf '%s ✗  exit %s%s\n' (set_color -o brred) $code (set_color normal)
    end

    printf '\e[5 q'
end

# ── Syntax highlighting — Catppuccin Mocha / purple+orange ─────
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
