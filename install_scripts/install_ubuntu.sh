# nvidia drivers
sudo apt update
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt install -y nvidia-driver-525

# Install some utilities
sudo apt install -y neovim vim zsh curl

# Install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Download tools
cd Downloads

## VsCode
wget https://az764295.vo.msecnd.net/stable/97dec172d3256f8ca4bfb2143f3f76b503ca0534/code_1.74.3-1673284829_amd64.deb
sudo dpkg -i code_1.74.3-1673284829_amd64.deb

#### Install docker
# Set up official repo
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Install docker engine
sudo apt update 
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
