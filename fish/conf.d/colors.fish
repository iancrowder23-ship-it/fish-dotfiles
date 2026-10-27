# ══════════════════════════════════════════════════════════════
#  colors.fish — syntax, git-prompt and greeting colors
#  Everything uses ANSI color names, so it follows the active
#  kitty theme (picked with `theme-pick`). The one accent color
#  comes from the universal var $dotfiles_accent.
# ══════════════════════════════════════════════════════════════
status is-interactive; or return

set -l a green
set -q dotfiles_accent[1]; and set a $dotfiles_accent

# ── Syntax highlighting ─────────────────────────────────────────
set -g fish_color_command           $a
set -g fish_color_param             normal
set -g fish_color_option            brblack
set -g fish_color_keyword           white
set -g fish_color_builtin           br$a   # fish ≥4.8.1
set -g fish_color_function          $a     # fish ≥4.8.1
set -g fish_color_operator          brblack
set -g fish_color_redirection       white
set -g fish_color_end               brblack
set -g fish_color_error             red
set -g fish_color_comment           brblack
set -g fish_color_quote             $a
set -g fish_color_autosuggestion    brblack
set -g fish_color_search_match      --background=brblack
set -g fish_color_selection         --background=brblack
set -g fish_pager_color_prefix      $a
set -g fish_pager_color_completion  normal
set -g fish_pager_color_description brblack
set -g fish_pager_color_progress    $a

# ── Git prompt colors ────────────────────────────────────────────
set -g __fish_git_prompt_color_branch          $a
set -g __fish_git_prompt_color_upstream_ahead  $a
set -g __fish_git_prompt_color_upstream_behind red
set -g __fish_git_prompt_color_dirty           white
set -g __fish_git_prompt_color_staged          $a
set -g __fish_git_prompt_color_invalidstate    red
set -g __fish_git_prompt_color_untrackedfiles  white

# ── Greeting gradient (grey → accent → grey) ─────────────────────
set -g fish_greeting_gradient brblack white br$a $a br$a white brblack
set -g fish_greeting_accent   brblack
