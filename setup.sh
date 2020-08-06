sudo apt update && sudo apt upgrade -y

git clone https://github.com/revotus/dotfiles.git .config

sudo apt install -y neovim fish

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

sudo chsh -s /usr/bin/fish fotus

su - $USER

curl -fsSL test.docker.com -o get-docker.sh && sh get-docker.sh

sudo usermod -aG docker $USER

# sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# sudo chmod +x /usr/local/bin/docker-compose

sudo apt install -y python3-pip

sudo apt install libffi-dev

sudo pip3 install docker-compose

mkdir repos; and cd repos

git clone https://github.com/dperson/samba