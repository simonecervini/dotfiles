This repository is the only source of truth for all dotfiles and configuration.

NEVER modify installed or live configuration outside this repository, including `~/.config/**`, `~/.claude/**`, `~/.zshrc`, and `~/.gitconfig`. Always modify the tracked source in this repository.

The user manages dotfiles from this repository with `bash install.sh`. NEVER modify files installed by that script. The user runs it manually. Run it only when explicitly requested.
