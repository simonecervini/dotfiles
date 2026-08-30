# OpenCode V2 runs `!` commands in non-interactive Zsh, which does not load
# .zshrc. OpenCode sets this variable, so restore the V1 behavior for its shells.
if [[ "$OPENCODE_TERMINAL" == "1" ]]; then
  source "$HOME/.zshrc"
fi
