function theme-pick --description 'Pick a kitty color theme + accent and recolor the whole setup'
    argparse h/help 'a/accent=' -- $argv; or return

    set -l accents red green yellow blue magenta cyan

    if set -q _flag_help
        echo 'Usage: theme-pick [--accent COLOR] [KITTY THEME NAME]'
        echo
        echo '  No theme name: opens kitty'"'"'s interactive theme browser'
        echo '                 (skipped when only --accent is given).'
        echo '  No --accent:   asks which theme color to use as the accent.'
        echo "  Accents: $accents"
        return 0
    end

    if set -q _flag_accent; and not contains -- $_flag_accent $accents
        echo "theme-pick: unknown accent '$_flag_accent' (choose: $accents)" >&2
        return 1
    end

    # ── 1. kitty theme ────────────────────────────────────────────
    # Writes to themes.conf (included by kitty.conf), never kitty.conf
    # itself, so redeploying kitty.conf can't wipe the chosen theme.
    set -l theme (string join ' ' -- $argv)
    if test -z "$theme"; and set -q _flag_accent
        # --accent alone: just recolor, don't open the browser
    else if command -q kitten
        if test -n "$theme"
            kitten themes --config-file-name themes.conf --reload-in=all $theme
            or echo "theme-pick: kitten themes couldn't apply '$theme' — keeping current theme" >&2
        else
            kitten themes --config-file-name themes.conf --reload-in=all
            or echo 'theme-pick: theme browser exited — keeping current theme' >&2
        end
    else
        echo 'theme-pick: kitten not found (install kitty) — skipping terminal theme' >&2
    end

    # ── 2. accent ─────────────────────────────────────────────────
    set -l current green
    set -q dotfiles_accent[1]; and set current $dotfiles_accent

    if set -q _flag_accent
        set -U dotfiles_accent $_flag_accent
    else if isatty stdin
        echo
        echo 'Pick an accent color (shown in your terminal theme'"'"'s colors):'
        for i in (seq (count $accents))
            set -l c $accents[$i]
            set -l mark ' '
            test $c = $current; and set mark '*'
            printf '  %s%d) %s██%s██%s %s\n' $mark $i (set_color $c) (set_color br$c) (set_color normal) $c
        end
        read -l -P "Choice [keep $current]: " choice
        if string match -qr '^[1-6]$' -- $choice
            set -U dotfiles_accent $accents[$choice]
        else
            set -U dotfiles_accent $current
        end
    else
        set -U dotfiles_accent $current
    end

    # ── 3. apply ──────────────────────────────────────────────────
    dotfiles-apply-colors
    echo "Accent: $dotfiles_accent"
end
