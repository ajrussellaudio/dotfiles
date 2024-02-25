echo "Creating an SSH key for you..."
ssh-keygen -t rsa

echo "Please add this public key to Github \n"
echo "https://github.com/account/ssh \n"
read -p "Press [Enter] key after this..."

if ! command -v brew &> /dev/null; then
  echo "Homebrew not installed."
  echo "Installing Homebrew..."
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing all the things..."
brew bundle

# Git shit
echo "Configuring git:"
git config --global user.name "Alan Russell"
git config --global user.email "ajrussellaudio@gmail.com"
