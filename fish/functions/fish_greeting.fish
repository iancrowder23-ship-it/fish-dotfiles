function fish_greeting
    # Typewriter animation — gradient set from the accent in
    # conf.d/colors.fish (fish_greeting_gradient / fish_greeting_accent)
    set -l colors $fish_greeting_gradient
    if test (count $colors) -eq 0
        set colors brblack white green   # fallback if colors.fish not loaded
    end
    set -l accent $fish_greeting_accent
    if test -z "$accent"
        set accent $colors[1]
    end

    # Greet whoever is logged in (`id -un` = the active account's username)
    set -l msg "  Welcome back, "(id -un)
    set -l len (string length $msg)

    for i in (seq $len)
        set -l char (string sub --start $i --length 1 $msg)
        set -l ci (math "($i - 1) % "(count $colors)" + 1")
        printf "%s%s" (set_color $colors[$ci]) $char
        sleep 0.012
    end
    printf "%s\n" (set_color normal)

    # ── fastfetch on every new shell ───────────────────────────
    # The logo tile is a kitty graphics image; anywhere else (tmux,
    # TTY, other terminals) use fastfetch's small text Arch logo
    if command -q fastfetch
        if test "$TERM" = xterm-kitty
            fastfetch
        else
            fastfetch --logo-type builtin --logo arch_small
        end
    end
end
