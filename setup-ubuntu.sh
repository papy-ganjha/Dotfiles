# General updates
sudo apt update && sudo apt upgrade -y

# Install python and deps
sudo apt install python3.8 python3.8-venv python3.8-dev

# Install docker and configure without sudo
sudo apt install docker docker.io docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Install CUDA and CUDNN
./setup-cuda-ubuntu.sh

# Install Brave Browser and curl
sudo apt install curl

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-rele
ase.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-
browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release
.list
sudo apt update && sudo apt install brave-browser

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


# copy the dot files to the root folder
ln -s .* ~/
