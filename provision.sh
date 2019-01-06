#!/bin/bash

function SECT() {
  echo -e "------------------------------------------------------------------"
  echo -e "$(date +'%Y/%m/%d %H:%M:%S')"
  echo -e "[$(basename $0)]\n\e[33m\e[46m $@ \e[m"
  echo -e "------------------------------------------------------------------"
}

sh_dir=$(cd $(dirname $0) && pwd)
echo sh_dir=${sh_dir}

#----------------------------------------------------------------------------
SECT "Set alias"
echo "alias ll='ls -Ula'" >> ${HOME}/.bash_profile
echo "alias ll='ls -Ula'" | sudo tee -a /root/.bash_profile

#----------------------------------------------------------------------------
SECT "Update package list(pacman -Syy)"
sudo pacman -Syy

#----------------------------------------------------------------------------
SECT "Install Yaourt"
sudo pacman -S --needed --noconfirm base-devel gcc git wget yajl
cd /tmp
git clone https://aur.archlinux.org/package-query.git
cd package-query/
yes 'Y'| makepkg -si
cd /tmp
git clone https://aur.archlinux.org/yaourt.git
cd yaourt
yes 'Y'| makepkg -si
cd /tmp
sudo rm -dR yaourt/ package-query/
cd ${sh_dir}

#----------------------------------------------------------------------------
SECT "Setup LANG and timezone"
sudo timedatectl set-timezone Asia/Tokyo
sudo cat << 'EOF' | sudo tee /etc/locale.conf
LANG=ja_JP.UTF8
LC_NUMERIC=ja_JP.UTF8
LC_TIME=ja_JP.UTF8
LC_MONETARY=ja_JP.UTF8
LC_PAPER=ja_JP.UTF8
LC_MEASUREMENT=ja_JP.UTF8
EOF
sudo mv /etc/locale.gen{,.bac}
echo ja_JP.UTF-8 UTF-8 | sudo tee /etc/locale.gen
sudo locale-gen

#----------------------------------------------------------------------------
SECT "Update mirrorlist"
sudo pacman -S --noconfirm reflector
sudo cp /etc/pacman.d/mirrorlist{,.bac}
sudo reflector --verbose --country 'Japan' -l 10 --sort rate --save /etc/pacman.d/mirrorlist

#----------------------------------------------------------------------------
SECT "Remove libxfont for pacman datebase error"
sudo pacman -Rdd --noconfirm libxfont

#----------------------------------------------------------------------------
SECT "Install powerpill"
gpg --recv-keys 1D1F0DC78F173680
yaourt -S --noconfirm powerpill
sudo sed -ie 's/Required DatabaseOptional/PackageRequired/' /etc/pacman.conf

#----------------------------------------------------------------------------
SECT "Install GUI(1/2: xorg-server, Xorg-xinit, lightdm-gtk-greeter)"
sudo pacman -S --noconfirm xorg-server xorg-xinit lightdm-gtk-greeter
SECT "Install GUI(2/2: xfce4 lightdm)"
yes 'all' | sudo pacman -S --noconfirm xfce4 lightdm
sudo systemctl enable lightdm.service
sudo systemctl set-default graphical.target
sudo pacman -S --noconfirm accountsservice packagekit

#----------------------------------------------------------------------------
SECT "Install or Remove-and-install VirtualBox Guest Additions"
sudo pacman -R --noconfirm virtualbox-guest-utils virtualbox-guest-utils-nox
sudo pacman -S --noconfirm virtualbox-guest-utils virtualbox-guest-dkms
sudo modprobe -a vboxguest vboxvideo
sudo cat << 'EOF' | sudo tee /etc/modules-load.d/virtualbox.conf
vboxguest
vboxvideo
EOF
sudo pacman -S --noconfirm virtualbox-guest-dkms

#----------------------------------------------------------------------------
SECT "Install xf86-video-vesa, xf86-video-fbdev"
sudo pacman -S --noconfirm xf86-video-vesa xf86-video-fbdev

#----------------------------------------------------------------------------
SECT "Install Japanese font and input method"
yaourt -S --noconfirm otf-takao
yes 'all' | sudo pacman -S --noconfirm fcitx-im fcitx-configtool fcitx-mozc
sudo cat << 'EOF' > ${HOME}/.xprofile
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
EOF

#----------------------------------------------------------------------------
SECT "Keyboard setting(Normally skip.. if you needed, remove #comment)"
#sudo localectl set-keymap jp106

#----------------------------------------------------------------------------
SECT "Install web browser(chromium)"
sudo pacman -S --noconfirm chromium

#----------------------------------------------------------------------------
SECT "Install docker, docker-compose"
sudo pacman -S --noconfirm docker docker-compose
sudo systemctl enable docker
sudo groupadd docker
sudo gpasswd -a vagrant docker
sudo systemctl restart docker

#----------------------------------------------------------------------------
SECT "Diet disk space. "
echo This may takes several minutes.
sudo dd if=/dev/zero of=zero bs=4k; rm -f zero

#----------------------------------------------------------------------------
SECT "Reboot after 10 sec."
sleep 10

#----------------------------------------------------------------------------
SECT "Going to reboot"
sleep 3
shutdown -r now
