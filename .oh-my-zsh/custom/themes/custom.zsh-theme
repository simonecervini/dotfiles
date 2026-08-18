ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg_bold[yellow]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[white]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

git_custom_status() {
  local cb=$(git_current_branch)
  if [ -n "$cb" ]; then
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(git_current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

aws_custom_status() {
  local profile region

  if [ -n "$AWS_ACCESS_KEY_ID" ]; then
    profile="env"
  else
    profile="${AWS_PROFILE:-$AWS_DEFAULT_PROFILE}"
  fi
  region="${AWS_REGION:-$AWS_DEFAULT_REGION}"

  if [ -n "$profile" ] || [ -n "$region" ]; then
    profile="${profile:-default}"
    [ -n "$region" ] && profile="$profile@$region"
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$profile$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

PROMPT='$(git_custom_status)$(aws_custom_status)%{$fg_bold[blue]%}[%~% ]%{$reset_color%}%B$%b '
