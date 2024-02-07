if test "$(id -u)" -gt "0"
  set blue (set_color blue)
  set bold (set_color -o blue)
  set normal (set_color normal)
  if test ! -f /etc/linuxbrew.firstrun
    printf "\nBluefin-CLI First Run Setup\n\n"
    printf "Setting up sudo for %s%s%s...\t\t\t " "$bold" "$USER" "$normal"
    echo "#$UID ALL = (root) NOPASSWD:ALL" | su-exec root tee -a /etc/sudoers > /dev/null
    printf "%s[ OK ]%s\n" "$blue" "$normal"
  end

  if test ! -d /home/linuxbrew/.linuxbrew
    set name $(hostname -s)
    set xdg_data_home "$XDG_DATA_HOME"
    test -z "$xdg_data_home"; and set xdg_data_home "$HOME/.local/share/"
    set linuxbrew_home "$xdg_data_home/bluefin-cli/$name"
    printf "Setting up Linuxbrew...\t\t\t\t "
    if test ! -d "$linuxbrew_home"
      mkdir -p "$linuxbrew_home"
    end
    if test ! -d /home/linuxbrew
      su-exec root mkdir -p /home/linuxbrew
    end
    su-exec root mount --bind "$linuxbrew_home" /home/linuxbrew
    su-exec root cp -R /home/homebrew/.linuxbrew /home/linuxbrew/
    su-exec root chown -R "$UID" /home/linuxbrew
    set -e linuxbrew_home
    printf "%s[ OK ]%s\n" "$blue" "$normal"
  end

  if test ! -d /usr/local/share/bash-completion/completions
    printf "Setting up Tab-Completions...\t\t\t "
    su-exec root mkdir -p /usr/local/share/bash-completion
    su-exec root mount --bind /run/host/usr/share/bash-completion /usr/local/share/bash-completion
    if test -x /run/host/usr/bin/ujust
      su-exec root ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/ujust
    end
    printf "%s[ OK ]%s\n" "$blue" "$normal"
  end

  if test ! -f /etc/linuxbrew.firstrun
    su-exec root touch /etc/linuxbrew.firstrun
    printf "\nBluefin-CLI first run complete!\n\n"
  end
end
