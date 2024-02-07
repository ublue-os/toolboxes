function fish_title
    set -q argv[1]; or set argv fish
    echo "$USER@$HOST" (fish_prompt_pwd_dir_length=1 prompt_pwd): $argv
end