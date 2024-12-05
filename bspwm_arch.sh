#########################  BASE PACKAGES  #########################   

pacman -S grub efibootmgr netctl dialog mtools dosfstools wpa_supplicant reflector bash-completion base-devel linux-headers cups rsync inetutils dnsutils gvfs gvfs-smb openssh nvidia nvidia-utils

#########################  CONFIG TP ADD MANUALLY #########################  


# add nvidia in the /etc/mkinitcpio.conf in the MODULES ()

# Add the font full package
paru nerd-fonts-complete

#########################  
