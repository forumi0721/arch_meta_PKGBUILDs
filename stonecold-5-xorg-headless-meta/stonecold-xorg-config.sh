#!/bin/sh

sed -i "s/^#display-setup-script=/display-setup-script=\/etc\/lightdm\/display-setup-script.sh/g" /etc/lightdm/lightdm.conf 
sed -i "s/^#xserver-command=X/xserver-command=X -s 0 dpms/g" /etc/lightdm/lightdm.conf
