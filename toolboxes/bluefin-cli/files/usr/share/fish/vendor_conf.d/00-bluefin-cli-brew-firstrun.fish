if test "$(id -u)" -gt "0"
  set blue (set_color blue)
  set bold (set_color -o blue)
  set normal (set_color normal)
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
      sudo mkdir -p /home/linuxbrew
    end
    sudo mount --bind "$linuxbrew_home" /home/linuxbrew
    sudo cp -R /home/homebrew/.linuxbrew /home/linuxbrew/
    sudo chown -R "$UID" /home/linuxbrew
    set -e linuxbrew_home
    printf "%s[ OK ]%s\n" "$blue" "$normal"
  end

  if test -x /run/host/usr/bin/ujust
    sudo ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/ujust
  end

  if test ! -f /etc/linuxbrew.firstrun
    sudo touch /etc/linuxbrew.firstrun
    printf "\nBluefin-CLI first run complete!\n\n"
  end
end
