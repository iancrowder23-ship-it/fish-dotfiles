function dotfiles-apply-colors --description 'Sync starship, fastfetch and fish colors to the kitty theme + $dotfiles_accent'
    set -l a green
    set -q dotfiles_accent[1]; and set a $dotfiles_accent
    set -l names red green yellow blue magenta cyan
    set -l i (contains -i -- $a $names); or set i 2

    # ── Read the active kitty theme ───────────────────────────────
    # kitty's built-in defaults, overridden by whatever `kitten themes`
    # wrote (themes.conf → include current-theme.conf)
    set -l kc_background 000000
    set -l kc_foreground dddddd
    set -l kc_color0 000000; set -l kc_color8  767676
    set -l kc_color1 cc0403; set -l kc_color9  f2201f
    set -l kc_color2 19cb00; set -l kc_color10 23fd00
    set -l kc_color3 cecb00; set -l kc_color11 fffd00
    set -l kc_color4 0d73cc; set -l kc_color12 1a8fff
    set -l kc_color5 cb1ed1; set -l kc_color13 fd28ff
    set -l kc_color6 0dcdcd; set -l kc_color14 14ffff
    set -l kc_color7 dddddd; set -l kc_color15 ffffff

    set -l kdir ~/.config/kitty
    set -q KITTY_CONFIG_DIRECTORY[1]; and set kdir $KITTY_CONFIG_DIRECTORY
    # theme-pick includes it from themes.conf; a plain `kitten themes`
    # run includes it from kitty.conf
    set -l files $kdir/themes.conf
    if cat $kdir/themes.conf $kdir/kitty.conf 2>/dev/null | string match -q '*current-theme.conf*'
        set -a files $kdir/current-theme.conf
    end
    for line in (cat $files 2>/dev/null)
        set -l m (string match -r '^\s*(background|foreground|color[0-9]|color1[0-5])\s+#([0-9a-fA-F]{6})\b' -- $line)
        and set kc_$m[2] (string lower $m[3])
    end

    set -l accent_var kc_color$i
    set -l bright_var kc_color(math $i + 8)
    set -l accent_hex $$accent_var
    set -l bright_hex $$bright_var

    # ── starship prompt ───────────────────────────────────────────
    # Rewrite only the [palettes.dotfiles] values; layout edits
    # survive. Surfaces are the theme background blended toward its
    # foreground, so segments sit on the theme instead of on color0
    # (which many themes make darker than the background).
    # Starship re-reads its config on every prompt — all open tabs
    # pick this up at their next prompt.
    # A starship.toml without our palette is someone else's — skip it.
    set -l cfg ~/.config/starship.toml
    if test -f $cfg; and string match -q '[palettes.dotfiles]' <$cfg
        set -l surface  (__dotfiles_mix $kc_background $kc_foreground 0.12)
        set -l surface2 (__dotfiles_mix $kc_background $kc_foreground 0.22)
        string replace -r '^accent = .*'        "accent = \"#$accent_hex\"" <$cfg \
            | string replace -r '^accent_bright = .*' "accent_bright = \"#$bright_hex\"" \
            | string replace -r '^surface = .*'       "surface = \"#$surface\"" \
            | string replace -r '^surface2 = .*'      "surface2 = \"#$surface2\"" >$cfg.tmp
        and mv $cfg.tmp $cfg
    end

    # ── fastfetch ─────────────────────────────────────────────────
    # Template uses ANSI SGR codes: @ACCENT@ = 3x, @ACCENT2@ = 9x
    set -l tpl ~/.config/fastfetch/config.jsonc.in
    if test -f $tpl
        string replace -a @ACCENT@ (math 30 + $i) <$tpl \
            | string replace -a @ACCENT2@ (math 90 + $i) >~/.config/fastfetch/config.jsonc
    end

    # Stale universals from the old hex-theme installs shadow nothing
    # now (conf.d/colors.fish sets globals), but clear them anyway.
    set -Ue fish_greeting_gradient fish_greeting_accent 2>/dev/null

    # Remember when we last synced, for conf.d/theme-sync.fish
    mkdir -p ~/.cache/fish-dotfiles
    touch ~/.cache/fish-dotfiles/colors.stamp

    # Refresh syntax/greeting colors in the current session
    source ~/.config/fish/conf.d/colors.fish
end

function __dotfiles_mix --argument-names from to t
    # Blend two rrggbb colors: t=0 → from, t=1 → to
    set -l out
    for pos in 1 3 5
        set -l x (math 0x(string sub -s $pos -l 2 $from))
        set -l y (math 0x(string sub -s $pos -l 2 $to))
        set -a out (printf '%02x' (math -s0 "$x + ($y - $x) * $t"))
    end
    string join '' $out
end
