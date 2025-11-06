# default path
DEVELOPER_PATH=~/Developer
cd $DEVELOPER_PATH

# fnm (optional)
command -v fnm &>/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"

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
wip() {
    current_branch=$(git branch --show-current)
    protected_branches=("main" "master" "production" "prod")
    
    for branch in "${protected_branches[@]}"; do
        if [[ "$current_branch" == "$branch" ]]; then
            echo "Error: Cannot push WIP commit to $current_branch branch (protected branch)"
            return 1
        fi
    done
    
    git add . && git commit -m "wip" --no-verify --allow-empty && git push
}
alias git-browse="git remote get-url origin | sed 's/git@\([^:]*\):\(.*\)\.git/https:\/\/\1\/\2/' | xargs open"
alias git-new-branch='git checkout -b sc/$(head -c 16 /dev/urandom | md5 | cut -c 1-6)'

# docker utilities
alias docker-stop-all='docker stop $(docker ps -a -q)'

# Misc utilities
alias aws-whoami='aws --no-cli-pager sts get-caller-identity --query "Arn" --output text'
alias clearhist='rm ~/.zsh_history'
alias nukedotenv='find . -type f -name ".env*" -print -exec rm -f {} \;'
alias update-hosts="sudo node $DEVELOPER_PATH/code/dotfiles/scripts-js/update-hosts.js"
alias import-config="cd $DEVELOPER_PATH/code/dotfiles && bash install.sh"

# `k` command (kill all processes running on a port)
kill_port() {
    if [ -z "$1" ]; then
        echo "Usage: k <port_number>"
        return 1
    fi

    PORT=$1
    PIDS=$(lsof -t -i:"$PORT")

    if [ -z "$PIDS" ]; then
        echo "No processes found running on port $PORT"
        return 0
    fi

    echo "Killing processes on port $PORT: $PIDS"
    kill -9 $PIDS
}
alias k='kill_port'