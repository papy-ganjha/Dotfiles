# General updates
sudo apt update && sudo apt upgrade -y

# Install python and deps
sudo apt install python3.8 python3.8-venv python3.8-dev

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
