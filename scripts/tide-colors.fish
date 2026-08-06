#!/usr/bin/env fish
# ══════════════════════════════════════════════════════════════
#  Monochrome grey + green tide prompt colors.
#
#  Run AFTER `tide configure` (which owns structure/layout/items/
#  separators/frame — this script never touches those). This
#  script ONLY overrides *_color / *_bg_color variables.
#
#  ── ROOT CAUSE OF THE "363636" LITERAL-TEXT BUG (verified against
#  IlanCosman/tide source, tag v6.2.0, cloned from
#  https://github.com/IlanCosman/tide) ──
#
#  `tide_left_prompt_separator_diff_color`,
#  `tide_right_prompt_separator_diff_color`,
#  `tide_left_prompt_separator_same_color` and
#  `tide_right_prompt_separator_same_color` are NOT color
#  variables despite the "_color" suffix in their names. They hold
#  a literal GLYPH/CHARACTER (e.g. an empty string, '│', or '╱')
#  that tide echoes RAW into the prompt. Proof:
#
#    functions/_tide_print_item.fish (upstream, lines 9-14):
#      else if test $_tide_side = left
#          set_color $prev_bg_color -b $item_bg_color
#          echo -ns $tide_left_prompt_separator_diff_color
#      else
#          set_color $item_bg_color -b $prev_bg_color
#          echo -ns $tide_right_prompt_separator_diff_color
#
#    set_color is called first (that's where an actual color
#    would apply, derived automatically from the adjacent segment
#    backgrounds — there is no user-settable color for the "diff"
#    separator). The variable's own CONTENTS are then printed
#    verbatim with a plain `echo`, not passed to set_color.
#
#    Confirmed again by tide's own wizard, which only ever
#    assigns character glyphs to these vars — never hex colors:
#      functions/tide/configure/choices/classic/classic_prompt_separators.fish
#        set -g fake_tide_left_prompt_separator_same_color │
#        set -g fake_tide_right_prompt_separator_same_color ╱
#    ...and its official presets ship them as blank/space/glyph,
#    e.g. functions/tide/configure/configs/lean.fish:
#      tide_left_prompt_separator_diff_color ' '
#
#  A previous version of this script set these four variables to
#  the hex string "363636", so tide printed the literal text
#  "363636" as the separator glyph immediately before the pwd
#  segment — exactly the ghost text the user saw next to the home
#  icon. This has NOTHING to do with `fake_tide_*` preview vars
#  (those only exist transiently inside `tide configure`'s wizard
#  process and are never read by the real prompt) and nothing to
#  do with `set -U` scope being wrong (universal is the correct,
#  tide-documented scope for all tide_* prompt vars).
#
#  FIX: this script no longer touches the four *_separator_*_color
#  glyph variables at all. Separator glyph choice belongs to
#  `tide configure`'s wizard (Prompt Separators step) and is left
#  alone, per this script's own "never touches structure" promise.
#  The two separator-related variables that ARE real colors —
#  `tide_prompt_color_frame_and_connection` (frame + connector
#  dots) and `tide_prompt_color_separator_same_color` (colorizes
#  the same-color separator glyph, see
#  functions/_tide_cache_variables.fish line 3: `set_color
#  $tide_prompt_color_separator_same_color | read -gx
#  _tide_color_separator_same_color`) — are still set below.
#
#  ── RELOAD BEHAVIOR (also verified against source, corrects an
#  earlier over-broad claim that "tide bakes ALL colors in at
#  session start") ──
#
#  Only `_tide_pwd`'s three anchor/dir/truncated colors
#  (tide_pwd_color_anchors, tide_pwd_color_dirs,
#  tide_pwd_color_truncated_dirs) are baked in at load time: in
#  functions/_tide_pwd.fish these are captured with `set_color`
#  into local variables and spliced via `eval` into the generated
#  `_tide_pwd` function body, and functions/fish_prompt.fish only
#  regenerates that function once, when fish_prompt.fish itself is
#  sourced (i.e. new shell / `tide reload`). Every other segment's
#  *_bg_color / *_color (pwd's own background included, plus git,
#  status, os, all language/tool segments, etc.) is read LIVE on
#  every prompt draw via indirect variable lookup in
#  functions/_tide_print_item.fish line 2:
#      v=tide_"$item"_bg_color set -f item_bg_color $$v
#  So most of this script's changes apply on the very next prompt;
#  only the three tide_pwd_color_* text colors need a fresh
#  session or `tide reload` (`fish -c 'tide reload'`, or `exec
#  fish`, or a brand-new terminal) to visually update.
# ══════════════════════════════════════════════════════════════

# Grey tiers (dark -> mid -> light), all desaturated/neutral grey
# 141414  darkest   - os, git, status, context, time (anchors)
# 262626  dark-mid  - pwd, cmd_duration, jobs (secondary anchors)
# 363636  light-mid - runtime/tool segments (node, python, docker, etc.)
# Green tiers for text/icons
# 39FF88  bright green - primary lettering/icons
# 22C55E  deep green   - secondary/truncated text
# Failure state stays legible: grey bg kept, red text only on error
# FF5C5C  failure red

set -U tide_os_bg_color              141414
set -U tide_os_color                 39FF88

set -U tide_pwd_bg_color             262626
set -U tide_pwd_color_anchors        39FF88
set -U tide_pwd_color_dirs           39FF88
set -U tide_pwd_color_truncated_dirs 22C55E

set -U tide_git_bg_color             141414
set -U tide_git_bg_color_unstable    141414
set -U tide_git_bg_color_urgent      141414
set -U tide_git_color_branch         39FF88
set -U tide_git_color_conflicted     FF5C5C
set -U tide_git_color_dirty          22C55E
set -U tide_git_color_operation      39FF88
set -U tide_git_color_staged         39FF88
set -U tide_git_color_stash          22C55E
set -U tide_git_color_untracked      22C55E
set -U tide_git_color_upstream       39FF88

set -U tide_character_color          39FF88
set -U tide_character_color_failure  FF5C5C

set -U tide_status_bg_color          141414
set -U tide_status_bg_color_failure  262626
set -U tide_status_color             39FF88
set -U tide_status_color_failure     FF5C5C

set -U tide_cmd_duration_bg_color    262626
set -U tide_cmd_duration_color       39FF88

set -U tide_context_bg_color         141414
set -U tide_context_color_default    39FF88
set -U tide_context_color_root       FF5C5C
set -U tide_context_color_ssh        22C55E

set -U tide_jobs_bg_color            262626
set -U tide_jobs_color               39FF88

set -U tide_time_bg_color            141414
set -U tide_time_color               39FF88

# ── Frame / connector colors ─────────────────────────────────────
# NOTE: tide_left/right_prompt_separator_{diff,same}_color are
# deliberately NOT set here — see the root-cause explanation
# above. They hold separator GLYPHS, not colors, and are owned by
# `tide configure`'s "Prompt Separators" step.
set -U tide_prompt_color_frame_and_connection  262626
set -U tide_prompt_color_separator_same_color  141414

# ── Language / tool runtime segments (own tier, still grey+green) ─
set -U tide_node_bg_color            363636
set -U tide_node_color               39FF88
set -U tide_python_bg_color          363636
set -U tide_python_color             39FF88
set -U tide_java_bg_color            363636
set -U tide_java_color               39FF88
set -U tide_ruby_bg_color            363636
set -U tide_ruby_color               39FF88
set -U tide_go_bg_color              363636
set -U tide_go_color                 39FF88
set -U tide_rustc_bg_color           363636
set -U tide_rustc_color              39FF88
set -U tide_php_bg_color             363636
set -U tide_php_color                39FF88
set -U tide_docker_bg_color          363636
set -U tide_docker_color             39FF88
set -U tide_kubectl_bg_color         363636
set -U tide_kubectl_color            39FF88
set -U tide_direnv_bg_color          363636
set -U tide_direnv_color             39FF88
set -U tide_direnv_bg_color_denied   262626
set -U tide_direnv_color_denied      FF5C5C
set -U tide_shlvl_bg_color           363636
set -U tide_shlvl_color              39FF88
set -U tide_gcloud_bg_color          363636
set -U tide_gcloud_color             39FF88
set -U tide_aws_bg_color             363636
set -U tide_aws_color                39FF88
set -U tide_terraform_bg_color       363636
set -U tide_terraform_color          39FF88
set -U tide_nix_shell_bg_color       363636
set -U tide_nix_shell_color          39FF88
set -U tide_toolbox_bg_color         363636
set -U tide_toolbox_color            39FF88
set -U tide_distrobox_bg_color       363636
set -U tide_distrobox_color          39FF88
set -U tide_pulumi_bg_color          363636
set -U tide_pulumi_color             39FF88
set -U tide_bun_bg_color             363636
set -U tide_bun_color                39FF88
set -U tide_elixir_bg_color          363636
set -U tide_elixir_color             39FF88
set -U tide_crystal_bg_color         363636
set -U tide_crystal_color            39FF88
set -U tide_zig_bg_color             363636
set -U tide_zig_color                39FF88

echo "Monochrome grey + green prompt colors applied."
echo "Most segments update on the very next prompt. The pwd path's"
echo "text colors (anchors/dirs/truncated) are cached into the"
echo "compiled _tide_pwd function at prompt-load time, so run"
echo "'tide reload' (or open a new terminal / exec fish) to see"
echo "those specific colors refresh."
