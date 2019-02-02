#!/usr/bin/env bash

function DIV() {
  echo -e "------------------------------------------------------------------"
  echo -e "$(date +'%Y/%m/%d %H:%M:%S')"
  echo -e "[$(basename $0)]\n\e[33m\e[46m $@ \e[m"
  echo -e "------------------------------------------------------------------"
}
sh_dir=$(cd $(dirname $0) && pwd)

# ================
# LOCALE SETTING
# ================
DIV "LOCALE SETTING"
sudo ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
sudo mv /etc/locale.gen /etc/locale.gen.old
echo "ja_JP.UTF-8 UTF-8" | sudo tee /etc/locale.gen
echo "LANG=ja_JP.UTF-8"| sudo tee /etc/locale.conf
sudo locale-gen

# ====================
# PACMAN REPO SETTING
# ====================
DIV "PACMAN REPO SETTING"
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm reflector
sudo cp /etc/pacman.d/mirrorlist{,.bac}
sudo reflector --verbose --country 'Japan' -l 10 --sort rate --save /etc/pacman.d/mirrorlist

# ===========
# ESSENTIALS
# ===========
sudo pacman -S --needed --noconfirm base-devel gcc git wget yajl libidn2

# =============
# AUR(YAOURT)
# =============
DIV "AUR(YAOURT)"
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

# =================================
# GUI: X-SERVER AND WINDOW MANAGER
# =================================
DIV "GUI: X-SERVER AND WINDOW MANAGER"
sudo pacman -S --noconfirm xorg-server lxde xfce4
sudo pacman -S --noconfirm ttf-liberation
sudo systemctl enable lxdm
sudo systemctl start lxdm
sudo pacman -S --noconfirm archlinux-wallpaper

# ===============================
# GUI: VIRTUALBOX-GUEST-ADDITION
# ===============================
DIV "GUI: VIRTUALBOX-GUEST-ADDITION"
sudo pacman -Rns --noconfirm virtualbox-guest-utils-nox
sudo pacman -Rns --noconfirm virtualbox-guest-dkms
sudo pacman -Rns --noconfirm virtualbox-guest-utils
sudo pacman -Rns --noconfirm virtualbox-guest-utils-nox
sudo pacman -Rns --noconfirm virtualbox-guest-modules-arch
sudo pacman -S --noconfirm virtualbox-guest-iso
sudo pacman -S --noconfirm linux-headers

# =============
# GUI: BROWSER
# =============
DIV "GUI: BROWSER"
sudo pacman -S --noconfirm firefox firefox-adblock-plus chromium

# ==============
# GUI: JAPANESE
# ==============
DIV "GUI: JAPANESE"
yaourt -S --noconfirm otf-takao
yes 'all' | sudo pacman -S --noconfirm fcitx-im fcitx-configtool fcitx-mozc
cat << 'EOF' > ${HOME}/.xprofile
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
EOF

# ======
# AUDIO
# ======
DIV "AUDIO"
amixer sset Master 100%+ unmute
alsactl store
sudo pacman -S --noconfirm alsa-utils
sudo pacman -S --noconfirm pulseaudio pulseaudio-alsa

