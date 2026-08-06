#!/usr/bin/env fish
# ══════════════════════════════════════════════════════════════
#  Monochrome grey + green tide prompt colors.
#  Run AFTER `tide configure` (which sets structure/layout/items/
#  separators/frame). This script ONLY overrides colors — every
#  segment gets an alternating dark-grey / light-grey background
#  with green text and icons, so the whole prompt reads as one
#  consistent monochrome+green look no matter which style you
#  picked in the wizard.
# ══════════════════════════════════════════════════════════════

set -l DARK   '1A1A1A'   # dark dark grey
set -l LIGHT  '3A3A3A'   # light light grey
set -l GREEN  '39FF88'   # prompt lettering / icons
set -l GREEN2 '2ECC71'   # slightly deeper green for secondary accents
set -l FAIL_BG '2A2A2A'  # failure state keeps a grey bg, not red — stays monochrome
set -l FAIL_FG 'FF5C5C'  # failure text needs to stay legible/distinct from success

# ── Left prompt segments ────────────────────────────────────────
set -U tide_os_bg_color               $DARK
set -U tide_os_color                  $GREEN
set -U tide_pwd_bg_color              $LIGHT
set -U tide_pwd_color_anchors         $GREEN
set -U tide_pwd_color_dirs            $GREEN
set -U tide_pwd_color_truncated_dirs  $GREEN2
set -U tide_git_bg_color              $DARK
set -U tide_git_bg_color_unstable     $DARK
set -U tide_git_bg_color_urgent       $DARK
set -U tide_git_color_branch          $GREEN
set -U tide_git_color_conflicted      $FAIL_FG
set -U tide_git_color_dirty           $GREEN
set -U tide_git_color_operation       $GREEN
set -U tide_git_color_staged          $GREEN
set -U tide_git_color_stash           $GREEN
set -U tide_git_color_untracked       $GREEN
set -U tide_git_color_upstream        $GREEN
set -U tide_character_color           $GREEN
set -U tide_character_color_failure   $FAIL_FG

# ── Right prompt segments ───────────────────────────────────────
set -U tide_status_bg_color           $DARK
set -U tide_status_bg_color_failure   $FAIL_BG
set -U tide_status_color              $GREEN
set -U tide_status_color_failure      $FAIL_FG
set -U tide_cmd_duration_bg_color     $LIGHT
set -U tide_cmd_duration_color        $GREEN
set -U tide_context_bg_color          $DARK
set -U tide_context_color_default     $GREEN
set -U tide_context_color_root        $FAIL_FG
set -U tide_context_color_ssh         $GREEN
set -U tide_jobs_bg_color             $LIGHT
set -U tide_jobs_color                $GREEN
set -U tide_time_bg_color             $DARK
set -U tide_time_color                $GREEN

# ── Frame / connector / separator colors ────────────────────────
set -U tide_prompt_color_frame_and_connection   $LIGHT
set -U tide_prompt_color_separator_same_color   $DARK
set -U tide_left_prompt_separator_diff_color    $LIGHT
set -U tide_left_prompt_separator_same_color    $LIGHT
set -U tide_right_prompt_separator_diff_color   $LIGHT
set -U tide_right_prompt_separator_same_color   $LIGHT

# ── Language / tool runtime segments (kept monochrome+green too) ─
set -U tide_node_bg_color             $LIGHT
set -U tide_node_color                $GREEN
set -U tide_python_bg_color           $LIGHT
set -U tide_python_color              $GREEN
set -U tide_java_bg_color             $LIGHT
set -U tide_java_color                $GREEN
set -U tide_ruby_bg_color             $LIGHT
set -U tide_ruby_color                $GREEN
set -U tide_go_bg_color               $LIGHT
set -U tide_go_color                  $GREEN
set -U tide_rustc_bg_color            $LIGHT
set -U tide_rustc_color               $GREEN
set -U tide_php_bg_color              $LIGHT
set -U tide_php_color                 $GREEN
set -U tide_docker_bg_color           $LIGHT
set -U tide_docker_color              $GREEN
set -U tide_kubectl_bg_color          $LIGHT
set -U tide_kubectl_color             $GREEN
set -U tide_direnv_bg_color           $LIGHT
set -U tide_direnv_color              $GREEN
set -U tide_direnv_bg_color_denied    $FAIL_BG
set -U tide_direnv_color_denied       $FAIL_FG
set -U tide_shlvl_bg_color            $LIGHT
set -U tide_shlvl_color               $GREEN
set -U tide_gcloud_bg_color           $LIGHT
set -U tide_gcloud_color              $GREEN
set -U tide_aws_bg_color              $LIGHT
set -U tide_aws_color                 $GREEN
set -U tide_terraform_bg_color        $LIGHT
set -U tide_terraform_color           $GREEN
set -U tide_nix_shell_bg_color        $LIGHT
set -U tide_nix_shell_color           $GREEN
set -U tide_toolbox_bg_color          $LIGHT
set -U tide_toolbox_color             $GREEN
set -U tide_distrobox_bg_color        $LIGHT
set -U tide_distrobox_color           $GREEN
set -U tide_pulumi_bg_color           $LIGHT
set -U tide_pulumi_color              $GREEN
set -U tide_bun_bg_color              $LIGHT
set -U tide_bun_color                 $GREEN
set -U tide_elixir_bg_color           $LIGHT
set -U tide_elixir_color              $GREEN
set -U tide_crystal_bg_color          $LIGHT
set -U tide_crystal_color             $GREEN
set -U tide_zig_bg_color              $LIGHT
set -U tide_zig_color                 $GREEN

echo "Monochrome grey + green prompt colors applied."
