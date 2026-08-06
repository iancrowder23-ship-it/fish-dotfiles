function fish_greeting
    # Typewriter animation — monochrome green gradient
    set -l colors 0B3D1A 145C29 17C93C 1FE84C 33FF66 4DFF80 66FF99 80FF9E 66FF99 4DFF80 33FF66 1FE84C 17C93C 145C29 0B3D1A D4D4D4
    set -l msg "  ❯ Welcome back, Ian ❯  "
    set -l len (string length $msg)

    for i in (seq $len)
        set -l char (string sub --start $i --length 1 $msg)
        set -l ci (math "($i - 1) % "(count $colors)" + 1")
        printf "%s%s" (set_color $colors[$ci]) $char
        sleep 0.012
    end
    printf "%s\n" (set_color normal)

    # Version info in dim green
    set -l kitty_ver (kitty --version 2>/dev/null | string match -r '\d+\.\d+\.\d+' | head -1)
    set -l fish_ver  (fish --version 2>/dev/null | string match -r '\d+\.\d+\.\d+' | head -1)
    printf "%s  kitty %s  •  fish %s%s\n" \
        (set_color 17C93C) \
        $kitty_ver \
        $fish_ver \
        (set_color normal)

    # ── fastfetch on every new shell ───────────────────────────
    if command -q fastfetch
        fastfetch
    end
end
