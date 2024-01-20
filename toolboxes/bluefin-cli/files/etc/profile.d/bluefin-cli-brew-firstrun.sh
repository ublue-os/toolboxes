if test "$(id -u)" -gt "0" && test ! -f /etc/linuxbrew.firstrun; then
  echo "First Run Setup"
  if test ! -d /home/linuxbrew; then
    mv /home/homebrew /home/linuxbrew
  else
    echo "Getting newest repo version of brew"
    su-exec root cp -R /home/homebrew/.linuxbrew /home/linuxbrew/
  fi
  echo "Making sure linuxbrew is owned by ${USER}"
  su-exec root chown -R $UID /home/linuxbrew
  echo "Setting up sudo for ${USER}"
  echo "#${UID} ALL = (root) NOPASSWD:ALL" | su-exec root tee -a /etc/sudoers > /dev/null
  su-exec root touch /etc/linuxbrew.firstrun
fi
