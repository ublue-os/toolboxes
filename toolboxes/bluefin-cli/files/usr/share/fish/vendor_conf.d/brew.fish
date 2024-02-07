if test "$(id -u)" -gt "0"
    set -gx PATH  $PATH /home/linuxbrew/.linuxbrew/bin
    set -gx HOMEBREW_PREFIX /home/linuxbrew/.linuxbrew
    set -gx HOMEBREW_CELLAR /home/linuxbrew/.linuxbrew/Cellar
    set -gx HOMEBREW_REPOSITORY /home/linuxbrew/.linuxbrew
end