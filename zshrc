# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'pc'

# Don't start tmux.
zstyle ':z4h:' start-tmux       no

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:192.168.10.160' enable 'yes'
zstyle ':z4h:ssh:192.168.10.112' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.

zstyle ':z4h:ssh:192.168.10.160' send-extra-files '~/.zshrc' #'~/.zsh_aliases' '~/.zsh_exports'
# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return
z4h install MichaelAquilina/zsh-you-should-use || return
z4h install redxtech/zsh-containers || return
z4h install greymd/docker-zsh-completion || return 
z4h install linnnus/autovenv || return 
#z4h install wbingli/zsh-wakatime || return 

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin
z4h load   MichaelAquilina/zsh-you-should-use
z4h load   ohmyzsh/ohmyzsh/plugins/git
z4h load   ohmyzsh/ohmyzsh/plugins/terraform
z4h load   ohmyzsh/ohmyzsh/plugins/ansible
z4h source linnnus/autovenv/autovenv.plugin.zsh
z4h load   ohmyzsh/ohmyzsh/plugins/archlinux
z4h load   ohmyzsh/ohmyzsh/plugins/dotenv
z4h load   ohmyzsh/ohmyzsh/plugins/gcloud
z4h load   ohmyzsh/ohmyzsh/plugins/git-auto-fetch
z4h load   ohmyzsh/ohmyzsh/plugins/git-extras
z4h load   ohmyzsh/ohmyzsh/plugins/git-flow
z4h load   ohmyzsh/ohmyzsh/plugins/gitignore
z4h load   ohmyzsh/ohmyzsh/plugins/kubectl
z4h load   ohmyzsh/ohmyzsh/plugins/pip
z4h load   ohmyzsh/ohmyzsh/plugins/sudo
z4h load   ohmyzsh/ohmyzsh/plugins/systemd
z4h load   ohmyzsh/ohmyzsh/plugins/vagrant
z4h source   redxtech/zsh-containers/containers.plugin.zsh
z4h source   greymd/docker-zsh-completion/docker-zsh-completion.plugin.zsh
#z4h load   wbingli/zsh-wakatime
#z4h source wbingli/zsh-wakatime/zsh-wakatime.plugin.zsh

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo Alt+/             # redo the last undone command line change

z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu
#zstyle 'z4h:powerlevel10k' disable 'yes'
source /home/$(whoami)/.zshaliases

#if [[ "$(hostname)" == "arch-desktop" ]] || [[ "$(hostname)" == "arch-laptop" ]]; then
#  source /home/$(whoami)/.zsh_exports
#  if [[ -f /home/$(whoami)/.zsh_secrets ]]; then
#    source /home/$(whoami)/.zsh_secrets
#  fi
#  eval "$(navi widget zsh)"
#else
#  if [[ "$(hostname)" == "arch-server" ]]; then
#  export PATH="$PATH:/home/admin/.hishtory"
#  source /home/admin/.hishtory/config.zsh
#    exit() {
#      secret="/home/$(whoami)/.zsh_secrets"
#      echo "Do you want to clean up files?[Y/N]"
#      read -r choice
#  
#      case "$choice" in
#        Y|y)
#          files_to_delete=(
#              "/home/$(whoami)/.zsh_aliases"
#              "/home/$(whoami)/.zsh_exports"
#              "/home/$(whoami)/.zsh_secrets"
#          )
#          for item in "${files_to_delete[@]}"; do
#              rm -rf "$item"
#              echo "Deleted $item"
#          done
#          ;;
#        N|n)
#          rm -rf "$secret"
#          echo "Deleted $secret"
#          ;;
#        *)
#          echo "You need to answer with Y or N."
#          return
#          ;;
#      esac
#  
#      builtin exit
#    }
#  fi
#fi

#precmd() {
#  HOUR=$(date +"%H")
#  DAY=$(date +"%u")
#  if [[ $HOUR -ge 8 && $HOUR -le 16 && $DAY -ge 1 && $DAY -le 5 ]]; then
#    export gcp_on=1
#  else
#    unset gcp_on
#  fi
#}

precmd() {
  if [[ -f .gcloudignore ]]; then
    export gcp_on=1
    return
  fi

  CUR_DIR="$PWD"
  while [[ "$CUR_DIR" != "/" ]]; do
    DIR_NAME=$(basename "$CUR_DIR")
    if [[ "$DIR_NAME" == "Devoteam" ]]; then
      export gcp_on=1
      return
    fi
    CUR_DIR=$(dirname "$CUR_DIR")
  done
  unset gcp_on
}

function crypt-unlock() {
    git-crypt unlock "$1"
    if [ $? -eq 0 ]; then
        for file in ~/.ssh/*; do
            perm=$(stat -c '%a' "$file")
            if [ "$perm" -ne "700" ]; then
                chmod 700 "$file"
            fi
        done
        echo "Unlock successful, permissions verified for ~/.ssh/*"
    else
        echo "Failed to unlock git-crypt. Check your key and permissions."
    fi
}



#neofetch


# The next line updates PATH for the Google Cloud SDK.
#if [ -f '/mnt/SharedSSD/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/mnt/SharedSSD/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
#if [ -f '/mnt/SharedSSD/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/mnt/SharedSSD/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
