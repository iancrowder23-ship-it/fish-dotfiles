#!/usr/bin/env fish
# ══════════════════════════════════════════════════════════════
#  Monochrome grey + green tide prompt colors.
#
#  Run AFTER `tide configure` (which owns structure/layout/items/
#  separators/frame — this script never touches those). This
#  script ONLY overrides *_color / *_bg_color variables, modeled
#  directly on tide's own official preset structure (see
#  IlanCosman/tide functions/tide/configure/configs/*.fish) —
#  those presets give each segment its OWN background tier
#  instead of flip-flopping between two identical shades, so
#  segment boundaries stay readable even without separators.
#  Values are hardcoded per-line (no intermediate variables) to
#  rule out any scoping ambiguity.
#
#  IMPORTANT: Tide bakes its color escape sequences into
#  fish_prompt/_tide_pwd via `eval` once, when fish_prompt.fish is
#  first loaded at session start — NOT read fresh on every prompt
#  render. That means changes made here will NOT visually apply
#  until you get a truly fresh fish session: open a new terminal
#  window/tab, or run `exec fish`. Reloading via `source` or `.`
#  is not enough.
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

# ── Frame / connector / separator colors ────────────────────────
set -U tide_prompt_color_frame_and_connection  262626
set -U tide_prompt_color_separator_same_color  141414
set -U tide_left_prompt_separator_diff_color   363636
set -U tide_left_prompt_separator_same_color   262626
set -U tide_right_prompt_separator_diff_color  363636
set -U tide_right_prompt_separator_same_color  262626

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
echo "Tide bakes prompt colors in at session start, so open a NEW terminal window/tab (or run: exec fish) to see them."
