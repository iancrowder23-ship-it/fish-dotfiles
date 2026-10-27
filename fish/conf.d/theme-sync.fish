# ══════════════════════════════════════════════════════════════
#  theme-sync.fish — if the kitty theme changed outside of
#  `theme-pick` (plain `kitten themes`, or DankMaterialShell
#  regenerating its wallpaper theme), re-sync the prompt and
#  fastfetch colors. Checked before every prompt, so open shells
#  follow a wallpaper change at their next Enter — it's only a few
#  file timestamp comparisons.
# ══════════════════════════════════════════════════════════════
status is-interactive; or return

function __dotfiles_theme_sync --on-event fish_prompt
    set -l kdir ~/.config/kitty
    set -q KITTY_CONFIG_DIRECTORY[1]; and set kdir $KITTY_CONFIG_DIRECTORY
    set -l stamp ~/.cache/fish-dotfiles/colors.stamp

    for f in $kdir/themes.conf $kdir/current-theme.conf $kdir/dank-theme.conf $kdir/dank-tabs.conf
        if test -f $f; and begin; not test -e $stamp; or test $f -nt $stamp; end
            dotfiles-apply-colors
            break
        end
    end
end
