# ══════════════════════════════════════════════════════════════
#  animations.fish — loaded at every fish startup via conf.d
#  Event handlers MUST live here, not in functions/, to register
# ══════════════════════════════════════════════════════════════

# Only in interactive shells — otherwise the escape codes below
# leak into the output of every `fish -c` / script run
status is-interactive; or return

# ── Default cursor: blinking beam ─────────────────────────────
printf '\e[5 q'

# ── On Enter: cursor morphs beam → underline → block ──────────
# The visual "click" feeling — cursor locks into a block while
# the command runs
function _cursor_preexec --on-event fish_preexec
    printf '\e[6 q'   # steady beam
    sleep 0.04
    printf '\e[4 q'   # steady underline
    sleep 0.04
    printf '\e[2 q'   # steady block — command is running
end

# ── After command: restore the blinking beam ───────────────────
# (Failures show in the prompt via starship's status module)
function _cursor_postexec --on-event fish_postexec
    printf '\e[5 q'
end

# Syntax highlighting colors live in conf.d/colors.fish
