# default path
DEVELOPER_PATH=~/Developer

# fnm
eval "$(fnm env --use-on-cd --shell zsh)"

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="custom"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# gpg
export GPG_TTY=$(tty)
alias gpg-reload='gpgconf --kill gpg-agent'

# custom git commands
export PATH="$HOME/.config/simonecervini/git-commands:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export PATH="$HOME/.bun/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

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
alias c='code'
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
alias git-empty='git commit --allow-empty -m "Empty commit"'
git-pr() {
    local remote_url=$(git remote get-url origin 2>/dev/null)
    local branch=$(git branch --show-current 2>/dev/null)
    
    if [[ -z "$remote_url" ]]; then
        echo "Error: Not a git repository or no remote 'origin' found"
        return 1
    fi
    
    if [[ -z "$branch" ]]; then
        echo "Error: Could not determine current branch"
        return 1
    fi
    
    local base_url=$(echo "$remote_url" | sed 's/git@\([^:]*\):/https:\/\/\1\//' | sed 's/\.git$//')
    
    if [[ "$remote_url" == *"github"* ]]; then
        if command -v gh &>/dev/null; then
            gh pr view --web 2>/dev/null || open "${base_url}/pulls?q=is%3Apr+head%3A${branch}"
        else
            open "${base_url}/pulls?q=is%3Apr+head%3A${branch}"
        fi
    elif [[ "$remote_url" == *"gitlab"* ]]; then
        if command -v glab &>/dev/null; then
            glab mr view --web 2>/dev/null || open "${base_url}/-/merge_requests?scope=all&state=all&source_branch=${branch}"
        else
            open "${base_url}/-/merge_requests?scope=all&state=all&source_branch=${branch}"
        fi
    else
        echo "Error: Unsupported git provider. Only GitHub and GitLab are supported."
        return 1
    fi
}

# docker utilities
alias docker-stop-all='docker stop $(docker ps -a -q)'

# Misc utilities
alias aws-whoami='aws --no-cli-pager sts get-caller-identity --query "Arn" --output text'
alias clearhist='rm ~/.zsh_history'
alias nukedotenv='find . -type f -name ".env*" -print -exec rm -f {} \;'
alias update-hosts="sudo node $DEVELOPER_PATH/code/dotfiles/scripts-js/update-hosts.js"
alias import-config="cd $DEVELOPER_PATH/code/dotfiles && bash install.sh"

# OpenCode
alias oc="opencode"
alias ocw="opencode web --port 4096 --hostname 127.0.0.1"
alias oca="opencode attach http://127.0.0.1:4096 --dir ."

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