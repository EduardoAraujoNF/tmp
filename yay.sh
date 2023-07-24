#!/bin/bash

echo 'Installing yay'
git clone https://aur.archlinux.org/yay.git &>> log
cd yay
makepkg -si --noconfirm >> log
if [ -f /sbin/yay ]; then
    echo 'Yay configured'
    cd ..
    echo 'Refreshing the mirrorlists...'
    yay -Suy --noconfirm >> log &
    echo 'Yay has been successfully installed!'
else
    echo 'Yay install failed, please check the log file'
fi

exit 0
