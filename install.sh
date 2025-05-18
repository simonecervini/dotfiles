#!/bin/zsh

cp .zshrc ~/.zshrc
cp .tmux.conf ~/.tmux.conf
rm -rf ~/.oh-my-zsh/custom && cp -R .oh-my-zsh/custom ~/.oh-my-zsh/custom
cp ghostty/config $HOME/Library/Application\ Support/com.mitchellh.ghostty/config
mkdir -p ~/.config/ghostty/themes
cp ghostty/custom-theme $HOME/.config/ghostty/themes/custom-theme

zsh -i -c 'omz reload'