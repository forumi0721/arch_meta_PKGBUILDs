#!/bin/sh

#ssh
if [ ! -e ~/.ssh ]; then
	mkdir -p ~/.ssh
	chmod 700 ~/.ssh
fi

for file in config authorized_keys id_rsa.pub id_rsa_aur.pub 
do
	if ! diff /usr/share/stonecold-home-config/${file} ~/.ssh/${file} &> /dev/null ; then
		cp -f /usr/share/stonecold-home-config/${file} ~/.ssh/${file}
		chmod 644 ~/.ssh/${file}
	fi
done
for file in id_rsa id_rsa_aur
do
	if ! diff /usr/share/stonecold-home-config/${file} ~/.ssh/${file} &> /dev/null ; then
		cp -f /usr/share/stonecold-home-config/${file} ~/.ssh/${file}
		chmod 600 ~/.ssh/${file}
	fi
done


#.gitconfig
if ! diff /usr/share/stonecold-home-config/gitconfig ~/.gitconfig &> /dev/null ; then
	cp -f /usr/share/stonecold-home-config/gitconfig ~/.gitconfig
	chmod 644 ~/.gitconfig
fi


#.xprofile
if ! diff /usr/share/stonecold-home-config/xprofile ~/.xprofile &> /dev/null ; then
	cp -f /usr/share/stonecold-home-config/xprofile ~/.xprofile
	chmod 644 ~/.xprofile
fi

#vnc
if [ ! -e ~/.vnc ]; then
	mkdir -p ~/.vnc
fi
if ! diff /usr/share/stonecold-home-config/passwd ~/.vnc/passwd &> /dev/null ; then
	cp -f /usr/share/stonecold-home-config/passwd ~/.vnc/passwd
	chmod 600 ~/.vnc/passwd
fi
if ! diff /usr/share/stonecold-home-config/xstartup ~/.vnc/xstartup &> /dev/null ; then
	cp -f /usr/share/stonecold-home-config/xstartup ~/.vnc/xstartup
	chmod 755 ~/.vnc/xstartup
fi


#skel
for skel in $(find /etc/skel/ -maxdepth 1 -mindepth 1)
do
	if ! diff ${skel} ~/"$(basename "${skel}")" &> /dev/null ; then
		cp -ar "${skel}" ~/
	fi
done
sed -i "s/^alias ls=/#^alias ls=/g" ~/.bashrc
sed -i "s/^PS1=/#PS1=/g" ~/.bashrc


#.zshrc
if [ ! -e ~/.zshrc ]; then
	touch ~/.zshrc
fi


#.bash_history
if [ "$(realpath ~/.bash_history)" != "/dev/null" ]; then
	ln -sf /dev/null ~/.bash_history
fi


exit 0

