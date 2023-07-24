#!/bin/bash

chaoticAurAppend="$(grep 'chaotic-aur' /etc/pacman.conf > /dev/null 2>&1 ; echo $?)"

echo 'Enabling Chaotic repository'
echo 'Installing the key...'
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com >> log
sudo pacman-key --lsign-key 3056513887B78AEB >> log

echo 'Downloading the keyring...'
sudo pacman -U --noconfirm 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' >> log

echo 'Downloading the mirrorlist...'
sudo pacman -U --noconfirm 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' >> log

if [ "${chaoticAurAppend}" -ne 0 ]; then
    echo 'Appending Chaotic in pacman.conf...'
    echo -e "\r\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
fi

echo 'Refreshing the mirrorlists...'
sudo pacman -Sy >> log

echo 'Chaotic has been successfully installed!'
exit 0
