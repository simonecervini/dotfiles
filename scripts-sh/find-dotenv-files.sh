#!/bin/zsh

DEFAULT_DIR=~/Developer
read -p "Enter the base directory to scan [default: $DEFAULT_DIR]: " BASE_DIR
BASE_DIR=${BASE_DIR:-$DEFAULT_DIR}

find "$BASE_DIR" -type f -name ".env*" ! -name ".env.example" ! -name ".env.local.example"