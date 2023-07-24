#!/bin/bash
chaoticAurAppend="$(grep 'chaotic-aur' /etc/pacman.conf > /dev/null 2>&1 ; echo $?)"

mkdir .tmp; cd .tmp
echo -en "Installing yay"
git clone https://aur.archlinux.org/yay.git &>> log
cd yay
makepkg -si --noconfirm >> log
if [ -f /sbin/yay ]; then
    echo -e "Yay configured"
    cd ..
    echo -en 'Refreshing the mirrorlists...'
    yay -Suy --noconfirm >> log &
    echo 'Yay has been successfully installed!'
else
    echo -e "Yay install failed, please check the log file"
    exit
fi

echo '---------------------------'
echo -en "Enabling Chaotic repository"
echo 'Installing the key...'
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com >> log
pacman-key --lsign-key 3056513887B78AEB >> log

echo 'Downloading the keyring...'
pacman -U --noconfirm 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' >> log

echo 'Downloading the mirrorlist...'
pacman -U --noconfirm 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' >> log

if [ "${chaoticAurAppend}" -ne 0 ]; then
    echo 'Appending Chaotic in pacman.conf...'
    echo -e "\r\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
fi

echo 'Refreshing the mirrorlists...'
pacman -Sy >> log

echo 'Chaotic has been successfully installed!'
exit 0