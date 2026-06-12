if status is-interactive

    # ── Done plugin: notify after commands > 5 seconds ────────
    set -g __done_min_cmd_duration 5000
    set -g __done_notification_urgency_level normal

    # ── Path ──────────────────────────────────────────────────
    # Homebrew (macOS only — dirs don't exist on Linux)
    if test -d /opt/homebrew/bin
        fish_add_path /opt/homebrew/bin
        fish_add_path /opt/homebrew/sbin
    end
    # User-local bins (Linux/Arch)
    if test -d ~/.local/bin
        fish_add_path ~/.local/bin
    end

    # ── Environment ───────────────────────────────────────────
    set -gx EDITOR nano
    set -gx VISUAL nano
    set -gx PAGER  less
    set -gx LESS   '-R'
    set -gx CLICOLOR 1

    # ── Git prompt settings ───────────────────────────────────
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showuntrackedfiles      1
    set -g __fish_git_prompt_showdirtystate          1
    set -g __fish_git_prompt_showstashstate          1
    set -g __fish_git_prompt_showupstream            informative

    # Catppuccin Mocha git colors
    set -g __fish_git_prompt_color_branch          brmagenta
    set -g __fish_git_prompt_color_upstream_ahead  brgreen
    set -g __fish_git_prompt_color_upstream_behind brred
    set -g __fish_git_prompt_color_dirty           bryellow
    set -g __fish_git_prompt_color_staged          brgreen
    set -g __fish_git_prompt_color_invalidstate    brred
    set -g __fish_git_prompt_color_untrackedfiles  brcyan

    # Git symbols
    set -g __fish_git_prompt_char_dirtystate       '✗'
    set -g __fish_git_prompt_char_stagedstate      '✓'
    set -g __fish_git_prompt_char_untrackedfiles   '…'
    set -g __fish_git_prompt_char_stashstate       '⚑'
    set -g __fish_git_prompt_char_upstream_ahead   '↑'
    set -g __fish_git_prompt_char_upstream_behind  '↓'
    set -g __fish_git_prompt_char_upstream_equal   '='

    # ── Aliases ───────────────────────────────────────────────

    # Listing — use eza if available, fall back to ls
    if command -q eza
        alias ls   'eza -lagh --icons --group-directories-first'
        alias l    'eza --long --all --header --icons --no-permissions --no-time --no-user --no-filesize --group-directories-first'
        alias ll   'eza -lagh --icons --group-directories-first'
        alias la   'eza -lagh --icons --group-directories-first --sort modified'
        alias tree 'eza -Ta --icons --ignore-glob="node_modules|.git|.DS_Store"'
    else
        alias ls   'ls -la'
        alias l    'ls -lah'
        alias ll   'ls -lah'
        alias la   'ls -A'
    end

    # Safety — confirm before clobber
    alias cp  'cp -Ri'
    alias mv  'mv -i'
    alias rm  'rm -i'

    # Colorize grep
    alias grep  'grep --color=auto'
    alias egrep 'egrep --color=auto'
    alias fgrep 'fgrep --color=auto'

    # Navigation
    alias ..    'cd ..'
    alias ...   'cd ../..'
    alias ....  'cd ../../..'
    alias ..... 'cd ../../../..'

    # Git
    alias g   'git'
    alias ga  'git add'
    alias gc  'git commit'
    alias gp  'git push'
    alias gs  'git status'
    alias gd  'git diff'
    alias gl  'git log --oneline --graph --decorate --color'

    # Network — OS-specific
    # (on Linux, `ip` is NOT aliased so iproute2 keeps working)
    alias myip 'dig +short myip.opendns.com @resolver1.opendns.com'
    switch (uname)
        case Darwin
            alias ip  'dig +short myip.opendns.com @resolver1.opendns.com'
            alias ipl 'ipconfig getifaddr en0'
        case Linux
            alias ipl "ip -4 -o addr show scope global | awk '{print \$4}' | cut -d/ -f1"
    end

    # ── Abbreviations (expand inline as you type) ─────────────
    abbr -a mk  mkdir -p
    abbr -a rmf rm -rf
    abbr -a py  python3
    abbr -a pip pip3
    abbr -a ni  npm install
    abbr -a ns  npm start
    abbr -a nd  npm run dev
    abbr -a nb  npm run build


end
