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

# ── Syntax highlighting — Mono-Green (grayscale + green accent) ─
set -g fish_color_command          33FF66   # commands       → bright green
set -g fish_color_param            D4D4D4   # arguments      → light gray
set -g fish_color_option           A0A0A0   # flags/options  → mid gray
set -g fish_color_keyword          17C93C   # keywords       → green
set -g fish_color_builtin          F2F2F2   # builtins       → near-white
set -g fish_color_operator         9EF5B3   # operators      → pale green
set -g fish_color_redirection      C7C7C7   # redirects      → gray
set -g fish_color_end              33FF66   # semicolons     → green
set -g fish_color_error            F2F2F2   # errors         → bold white (stands out on dark)
set -g fish_color_comment          4A4A4A   # comments       → dim gray
set -g fish_color_quote            9EF5B3   # strings        → pale green
set -g fish_color_autosuggestion   4A4A4A   # ghost text     → dim gray
set -g fish_color_search_match     --background=17C93C
set -g fish_color_selection        --background=17C93C
set -g fish_pager_color_prefix     33FF66
set -g fish_pager_color_completion D4D4D4
set -g fish_pager_color_description 4A4A4A
set -g fish_pager_color_progress   33FF66
