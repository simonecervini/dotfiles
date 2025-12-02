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

# wildid - generates a unique identifier (date-adjective-animal)
# usage: wildid [separator]
wildid() {
    source ~/.config/simonecervini/adjectives.sh
    source ~/.config/simonecervini/animals.sh
    
    local separator="${1:--}"
    local date_iso=$(date '+%Y-%m-%d')
    
    local adjective=$(printf '%s\n' "${ADJECTIVES[@]}" | sort -R | head -n1)
    local animal=$(printf '%s\n' "${ANIMALS[@]}" | sort -R | head -n1)
    
    echo "${date_iso}${separator}${adjective}${separator}${animal}"
}

# git utilities
git-wip() {
    current_branch=$(git branch --show-current)
    protected_branches=("main" "master" "production" "prod")
    
    for branch in "${protected_branches[@]}"; do
        if [[ "$current_branch" == "$branch" ]]; then
            echo "Error: Cannot push WIP commit to $current_branch branch (protected branch)"
            return 1
        fi
    done
    
    git add .
    
    timestamp=$(date '+%Y-%m-%d %H:%M:%S (%Z)')
    diff_stats=$(git diff --cached --stat | sed 's/^ *//')
    commit_msg="WIP 🚧

${diff_stats}

[skip ci]

T = $timestamp"
    
    git commit -m "$commit_msg" --no-verify --allow-empty && git push
}
git-sprout() {
    local id=$(wildid)
    branch_name="simone/${id}"
    git checkout -b "$branch_name"
}
git-shit() {
    git stash push -a -m "SHIT_$(date +%Y-%m-%d_%H:%M:%S)"
}
alias git-browse="git remote get-url origin | sed 's/git@\([^:]*\):\(.*\)\.git/https:\/\/\1\/\2/' | xargs open"
alias git-story='git log --oneline --decorate --color --abbrev-commit --date=relative --pretty=format:"%C(yellow)%h%C(reset) - %C(green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)%C(red)%d%C(reset)"'

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