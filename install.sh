#!/bin/zsh

cp .zshrc ~/.zshrc
cp .tmux.conf ~/.tmux.conf
rm -rf ~/.oh-my-zsh/custom && cp -R .oh-my-zsh/custom ~/.oh-my-zsh/custom
cp ghostty/config $HOME/Library/Application\ Support/com.mitchellh.ghostty/config
mkdir -p ~/.config/ghostty/themes
cp ghostty/custom-theme $HOME/.config/ghostty/themes/custom-theme
cp opencode/opencode.jsonc $HOME/.config/opencode/opencode.jsonc
cp cursor/settings.json $HOME/Library/Application\ Support/Cursor/User/settings.json
cp cursor/keybindings.json $HOME/Library/Application\ Support/Cursor/User/keybindings.json
cp cursor/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
cp cursor/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings.json
rm -rf ~/.config/simonecervini && mkdir -p ~/.config/simonecervini
cp scripts-sh/adjectives.sh ~/.config/simonecervini/adjectives.sh
cp scripts-sh/animals.sh ~/.config/simonecervini/animals.sh

zsh -i -c 'omz reload' || true