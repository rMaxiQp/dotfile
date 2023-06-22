#/bin/bash

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if we're on MacOS
# https://stackoverflow.com/a/8597411
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "MacOS detected"
else
    # Eventually... we can add support for other OSes
    echo "Not MacOS. Exiting..."
    exit 1
fi

# Install Homebrew
# https://stackoverflow.com/a/677212
if ! command -v brew &> /dev/null
then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install all packages in .brew
echo "Installing packages from .brew..."
cat $DOTFILES_DIR/.brew | xargs brew install

# Install oh-my-zsh
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp ~/.zshrc ~/.zshrc.bak
cp $DOTFILES_DIR/.zshrc ~/.zshrc
chsh -s $(which zsh)
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

# Install Vundle
echo "Installing Vundle..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp ~/.vimrc ~/.vimrc.bak
cp $DOTFILES_DIR/.vimrc ~/.vimrc
vim +PluginInstall +qall

# Update Git config
echo "Updating Git config..."
cp ~/.gitconfig ~/.gitconfig.bak
cp $DOTFILES_DIR/.gitconfig ~/.gitconfig