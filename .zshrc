# default path
DEVELOPER_PATH=~/Developer
cd $DEVELOPER_PATH

# nvm (oh-my-zsh plugin)
zstyle ':omz:plugins:nvm' lazy yes # speed-up zsh startup
zstyle ':omz:plugins:nvm' autoload yes

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="custom"
plugins=(git nvm)
source $ZSH/oh-my-zsh.sh

# gpg
export GPG_TTY=$(tty)
alias gpg-reload='gpgconf --kill gpg-agent'

# pnpm
export PNPM_HOME="/Users/$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
[ -s "/Users/$HOME/.bun/_bun" ] && source "/Users/$HOME/.bun/_bun"

# dev command
# usage: dev <project-name>
_dev_autocomplete() {
    # TODO: remove the /code from the path
    local projects_dir=$DEVELOPER_PATH/code
    _arguments '*:project name:->projects'
    case $state in
        projects)
            local -a projects
            projects=(${projects_dir}/*(N:t))
            _describe 'project' projects
            ;;
    esac
}
compdef _dev_autocomplete dev
dev() {
    if [ -z "$1" ]; then
        echo "Please specify a project name."
        return 1
    fi

    cd $DEVELOPER_PATH/code/$1

    if [[ $? != 0 ]]; then
        echo "The specified directory does not exist."
        return 1
    fi
}

# c command
alias c='cursor'
compdef _gnu_generic c

# git utilities
alias git-new-branch='git checkout -b sc/$(head -c 16 /dev/urandom | md5 | cut -c 1-6)'

# docker utilities
alias docker-stop-all='docker stop $(docker ps -a -q)'

# Misc utilities
alias clearhist='rm ~/.zsh_history'
alias nukedotenv='find . -type f -name ".env*" -print -exec rm -f {} \;'
alias update-hosts="sudo node $DEVELOPER_PATH/code/dotfiles/scripts-js/update-hosts.js"
alias import-config="cd $DEVELOPER_PATH/code/dotfiles && bash install.sh"