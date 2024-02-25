#! /bin/bash

# Mac shit
echo "Setting up macOS preferences..."

echo "- Requiring password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

SCREENSHOTS_FOLDER=~/Desktop/Screenshots
echo "- Saving screenshots to" $SCREENSHOTS_FOLDER
mkdir "$SCREENSHOTS_FOLDER"
defaults write com.apple.screencapture location -string "$SCREENSHOTS_FOLDER"

# Git shit

SSH_KEYFILE=~/.ssh/id_rsa
echo "Creating an SSH key for you..."
ssh-keygen -t rsa -f $SSH_KEYFILE
cat $SSH_KEYFILE.pub | pbcopy
echo "Contents of" $SSH_KEYFILE.pub "copied."
echo "Please add this public key to Github \n"
echo "https://github.com/account/ssh \n"
read -p "Press [Enter] key after this..."

# Install shit

if [ ! -d ~/.oh-my-zsh ]; then
  echo "Installing Oh My Zsh..."
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
fi

if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sh
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ./.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing all the things..."
brew bundle

echo "Migrating dotfiles..."
stow . --adopt

if command -v tmux &> /dev/null; then
  echo "Configuring tmux..."  
  tmux source ~/.config/tmux/tmux.conf
fi

