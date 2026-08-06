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

# ── Syntax highlighting / colors ────────────────────────────────
# Colors live in fish/themes/<name>.fish (deployed as
# conf.d/00-theme.fish by install.sh, loads before this file).
# See that file for fish_color_*, git-prompt, and greeting colors.
