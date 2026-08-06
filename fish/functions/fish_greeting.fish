function fish_greeting
    # Typewriter animation — gradient set by the active theme
    # (fish_greeting_gradient / fish_greeting_accent, universal
    # vars set in fish/themes/<name>.fish → conf.d/00-theme.fish)
    set -l colors $fish_greeting_gradient
    if test (count $colors) -eq 0
        set colors CBA6F7 89B4FA 34D399   # fallback if theme not applied yet
    end
    set -l accent $fish_greeting_accent
    if test -z "$accent"
        set accent $colors[1]
    end

    set -l msg "  ❯ Welcome back, Ian ❯  "
    set -l len (string length $msg)

    for i in (seq $len)
        set -l char (string sub --start $i --length 1 $msg)
        set -l ci (math "($i - 1) % "(count $colors)" + 1")
        printf "%s%s" (set_color $colors[$ci]) $char
        sleep 0.012
    end
    printf "%s\n" (set_color normal)

    # Version info in the theme's accent color
    set -l kitty_ver (kitty --version 2>/dev/null | string match -r '\d+\.\d+\.\d+' | head -1)
    set -l fish_ver  (fish --version 2>/dev/null | string match -r '\d+\.\d+\.\d+' | head -1)
    printf "%s  kitty %s  •  fish %s%s\n" \
        (set_color $accent) \
        $kitty_ver \
        $fish_ver \
        (set_color normal)

    # ── fastfetch on every new shell ───────────────────────────
    if command -q fastfetch
        fastfetch
    end
end
