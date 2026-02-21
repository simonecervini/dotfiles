#!/bin/zsh

# shell
cp .zshrc ~/.zshrc
cp .tmux.conf ~/.tmux.conf
rm -rf ~/.oh-my-zsh/custom && cp -R .oh-my-zsh/custom ~/.oh-my-zsh/custom

# ghostty
cp ghostty/config $HOME/Library/Application\ Support/com.mitchellh.ghostty/config
mkdir -p ~/.config/ghostty/themes
cp ghostty/custom-theme $HOME/.config/ghostty/themes/custom-theme

# opencode
rm -rf "$HOME/.config/opencode"
cp -R opencode "$HOME/.config/opencode"

# cursor & vscode (same settings for both)
for app in Cursor Code; do
  cp cursor/settings.json "$HOME/Library/Application Support/$app/User/settings.json"
  cp cursor/keybindings.json "$HOME/Library/Application Support/$app/User/keybindings.json"
  cp cursor/tasks.json "$HOME/Library/Application Support/$app/User/tasks.json"
done

# custom scripts (~/.config/simonecervini)
rm -rf ~/.config/simonecervini && mkdir -p ~/.config/simonecervini
cp scripts-sh/adjectives.sh ~/.config/simonecervini/adjectives.sh
cp scripts-sh/animals.sh ~/.config/simonecervini/animals.sh

# custom git commands (git-* in PATH → "git <name>")
mkdir -p ~/.config/simonecervini/git-commands
cp git/commands/* ~/.config/simonecervini/git-commands/
chmod +x ~/.config/simonecervini/git-commands/*

# reload
zsh -i -c 'omz reload' || true
