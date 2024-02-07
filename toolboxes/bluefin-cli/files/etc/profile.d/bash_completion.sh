# shellcheck shell=sh disable=SC1090,SC1091,SC2039,SC2166,SC2268
# Check for interactive bash and that we haven't already been sourced.
if [ "x${BASH_VERSION-}" != x -a "x${PS1-}" != x -a "x${BASH_COMPLETION_VERSINFO-}" = x ]; then

    # Check for recent enough version of bash.
    if [ "${BASH_VERSINFO[0]}" -gt 4 ] ||
        [ "${BASH_VERSINFO[0]}" -eq 4 -a "${BASH_VERSINFO[1]}" -ge 2 ]; then
        [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion" ] &&
            . "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion"
        if shopt -q progcomp && [ -d /usr/share/bash-completion/completions ]; then
            for rc in /usr/share/bash-completion/completions/*; do
                if test -r "$rc"; then
                    . "$rc"
                fi
            done
            unset rc
        fi
        if shopt -q progcomp && [ -r /usr/local/share/bash-completion/bash_completion ]; then
            # Source completion code.
            . /usr/local/share/bash-completion/bash_completion
        fi
        if ! test -L /home/linuxbrew/.linuxbrew/etc/bash_completion.d/brew && test "$(id -u)" -gt 0; then
            /home/linuxbrew/.linuxbrew/bin/brew completions link > /dev/null
        fi
        if test -d /home/linuxbrew/.linuxbrew/etc/bash_completion.d; then
            for rc in /home/linuxbrew/.linuxbrew/etc/bash_completion.d/*; do
              if test -r "$rc"; then
                . "$rc"
              fi
            done
            unset rc
        fi
        if test -d /run/host/etc/bash_completion.d; then
            for rc in /run/host/etc/bash_completion.d/*; do
                if test -r "$rc"; then
                    . "$rc"
                fi
            done
            unset rc
        fi
    fi
fi
