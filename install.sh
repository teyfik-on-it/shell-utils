#!/bin/bash

# Check for Git installation
if ! command -v git &>/dev/null; then
  echo "Git is not installed. Please install Git and try again."
  exit 1
fi

# Define the directory where the repository is to be cloned or updated
REPO_DIR="$HOME/shell-utils"
# Define the branch you want to reset to
RESET_BRANCH="main"

# Git operations: clone, pull, or reset
if [ -d "$REPO_DIR" ]; then
  pushd "$REPO_DIR" >/dev/null
  if ! git symbolic-ref -q HEAD >/dev/null; then
    echo "Detached installation, resetting..."
    git fetch origin &&
      git reset --hard "origin/$RESET_BRANCH" &&
      git clean -df
    if [ $? -ne 0 ]; then
      echo "Failed to reset installation. Exiting..."
      popd >/dev/null
      exit 1
    fi
  else
    echo "Updating installation..."
    if ! git pull; then
      echo "Failed to update! Exiting..."
      popd >/dev/null
      exit 1
    fi
  fi
  popd >/dev/null
else
  echo "Installing shell-utils..."
  if ! git clone https://github.com/teyfik-on-it/shell-utils.git "$REPO_DIR"; then
    echo "Failed to install shell-utils! Exiting..."
    exit 1
  fi
fi

# Assuming install.sh is within the cloned or updated repository
PROFILE_FILE="$HOME/.$(basename "$SHELL")rc"
SOURCE_COMMAND="source \"$REPO_DIR/bootstrap.sh\""

# Check if the source command is already in the profile file
if grep -qF -- "$SOURCE_COMMAND" "$PROFILE_FILE"; then
  echo "The source command is already in $PROFILE_FILE"
else
  echo "$SOURCE_COMMAND" >>"$PROFILE_FILE"
  echo "Added source command to $PROFILE_FILE"
fi
