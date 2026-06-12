function fish_greeting
    # Typewriter animation in purple → orange gradient
    set -l colors CBA6F7 B794F4 A78BFA 9333EA 7C3AED 8B5CF6 A78BFA C084FC E879F9 FAB387 FB923C F97316 EA580C F97316 FB923C FAB387
    set -l msg "  ❯ Welcome back, Ian ❯  "
    set -l len (string length $msg)

    for i in (seq $len)
        set -l char (string sub --start $i --length 1 $msg)
        set -l ci (math "($i - 1) % "(count $colors)" + 1")
        printf "%s%s" (set_color $colors[$ci]) $char
        sleep 0.012
    end
    printf "%s\n" (set_color normal)

    # Version info in muted purple
    set -l kitty_ver (kitty --version 2>/dev/null | string match -r '\d+\.\d+\.\d+' | head -1)
    set -l fish_ver  (fish --version 2>/dev/null | string match -r '\d+\.\d+\.\d+' | head -1)
    printf "%s  kitty %s  •  fish %s%s\n" \
        (set_color 6D28D9) \
        $kitty_ver \
        $fish_ver \
        (set_color normal)
end
