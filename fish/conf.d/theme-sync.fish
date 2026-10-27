# ══════════════════════════════════════════════════════════════
#  theme-sync.fish — if the kitty theme changed outside of
#  `theme-pick` (e.g. plain `kitten themes`), re-sync the prompt
#  and fastfetch colors on the next new shell
# ══════════════════════════════════════════════════════════════
status is-interactive; or return

set -l kdir ~/.config/kitty
set -q KITTY_CONFIG_DIRECTORY[1]; and set kdir $KITTY_CONFIG_DIRECTORY
set -l stamp ~/.cache/fish-dotfiles/colors.stamp

for f in $kdir/themes.conf $kdir/current-theme.conf
    if test -f $f; and begin; not test -e $stamp; or test $f -nt $stamp; end
        dotfiles-apply-colors
        break
    end
end
