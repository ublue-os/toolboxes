if test "$(id -u)" -gt "0"; then
  green=$'\033[32m'
  bold=$'\033[1m'
  normal=$'\033[0m'
  if test ! -f /etc/linuxbrew.firstrun; then
    printf "\nBluefin-CLI First Run Setup\n\n"
    printf "Setting up sudo for ${bold}${USER}${normal}...\t\t\t "
    echo "#${UID} ALL = (root) NOPASSWD:ALL" | su-exec root tee -a /etc/sudoers > /dev/null
    printf "${green}[ OK ]${normal}\n"
  fi

  if test ! -d /home/linuxbrew/.linuxbrew; then
    printf "Setting up Linuxbrew...\t\t\t\t "
    if test ! -d "${XDG_DATA_HOME:-$HOME/.local/share}"/bluefin-cli; then
      mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}"/bluefin-cli
    fi
    if test ! -d /home/linuxbrew; then
      su-exec root mkdir -p /home/linuxbrew
    fi
    su-exec root mount --bind "${XDG_DATA_HOME:-$HOME/.local/share}"/bluefin-cli /home/linuxbrew
    su-exec root cp -R /home/homebrew/.linuxbrew /home/linuxbrew/
    su-exec root chown -R $UID /home/linuxbrew
    printf "${green}[ OK ]${normal}\n"
  fi
  if test ! -d /usr/local/share/bash-completion/completions
    printf "Setting up Tab-Completions...\t\t\t "
    su-exec root mkdir -p /usr/local/share/bash-completion
    su-exec root mount --bind /run/host/usr/share/bash-completion /usr/local/share/bash-completion
    printf "${green}[ OK ]${normal}\n"
  fi

  if test ! -f /etc/linuxbrew.firstrun; then
    su-exec root touch /etc/linuxbrew.firstrun
    printf "\nBluefin-CLI first run complete!\n\n"
  fi
fi
