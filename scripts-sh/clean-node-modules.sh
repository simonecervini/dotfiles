#!/bin/zsh

DEFAULT_DIR=~/Developer

read -p "Enter the base directory to scan [default: $DEFAULT_DIR]: " BASE_DIR
BASE_DIR=${BASE_DIR:-$DEFAULT_DIR}

echo "Initial size of $BASE_DIR:"
du -sh "$BASE_DIR"

echo "Removing all node_modules folders in $BASE_DIR..."
find "$BASE_DIR" -type d -name "node_modules" -prune -exec rm -rf {} +

echo "Final size of $BASE_DIR:"
du -sh "$BASE_DIR"
