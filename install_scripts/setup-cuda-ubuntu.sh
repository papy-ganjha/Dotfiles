# Update the machine and download drivers for nvidia-card
sudo apt update && sudo apt upgrade -y
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt install -y nvidia-driver-520 nvidia-dkms-520 vim 

# Download the cuda toolkit 11.8 and install it
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2004-11-8-local/cuda-368EAC11-keyring.gpg /usr/share/keyrings/
sudo cp /var/cuda-repo-ubuntu2004-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt update
sudo apt install cuda


# Download CuDnn 8.2.x and install it in the path of the machine
wget https://developer.download.nvidia.com/compute/machine-learning/cudnn/secure/8.2.1.32/11.3_06072021/cudnn-11.3-linux-x64-v8.2.1.32.tgz?RJkcEcGRXjjDLPORfQRR0XxRmawNj8EbA_RUl4EJK-kFIIA--TXgVOLU7taGJocSeQ-MW3bcdfCFnnbEQoOhR77B2DJ3R0fGSUSa_CQMeEf_3dC3hlShvXX7bs1QUomOPYP8xNya6R99P3KBeMRLWVTEv_mTmaVO3kkbSxbOejxY5cFOesWSzz9zEsKuEqNZ8ZRlxpbM1j5r5wsXwSI=&t=eyJscyI6IndlYnNpdGUiLCJsc2QiOiJkZXZlbG9wZXIubnZpZGlhLmNvbS9sb2dpbiJ9 # Duno if the link will work
tar -xzvf cudnn-11.3-linux-x64-v8.2.1.32.tgz
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

# You have to add this to you local .bashrc file or whatever file
# export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64:$LD_LIBRARY_PATH
# export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

