# OpenCode runs `!` commands in non-interactive Zsh, which does not load .zshrc.
# OpenCode sets this variable, so load the interactive shell configuration.
if [[ "$OPENCODE_TERMINAL" == "1" ]]; then
  source "$HOME/.zshrc"
fi
