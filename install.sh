#!/bin/zsh

cp .zshrc ~/.zshrc
cp .tmux.conf ~/.tmux.conf
rm -rf ~/.oh-my-zsh/custom && cp -R .oh-my-zsh/custom ~/.oh-my-zsh/custom
cp ghostty $HOME/Library/Application\ Support/com.mitchellh.ghostty/config

zsh -i -c 'omz reload'