#!/bin/sh

if [ "${EUID}" != "0" ]; then
	sudo "${0}" $@
	exit $?
fi

#locale
if [ -e /etc/locale.gen ]; then
	if [ -z "$(grep "^ko_KR.UTF-8 UTF-8" /etc/locale.gen)" ]; then
		sed -i "s/^#ko_KR.UTF-8 UTF-8/ko_KR.UTF-8 UTF-8/g" /etc/locale.gen
		locale-gen
	fi

	if ! diff /usr/share/stonecold-base-config/locale.conf /etc/locale.conf &> /dev/null ; then
		cp -f /usr/share/stonecold-base-config/locale.conf /etc/locale.conf
		chmod 644 /etc/locale.conf
	fi
fi


#localtime
if [ "$(realpath /etc/localtime)" != "/usr/share/zoneinfo/Asia/Seoul" ]; then
	rm -rf /etc/localtime
	ln -sf ../usr/share/zoneinfo/Asia/Seoul /etc/localtime
fi


#skel
if [ -e /etc/skel/.bashrc ]; then
	sed -i "s/^alias ls=/#^alias ls=/g" /etc/skel/.bashrc
	sed -i "s/^PS1=/#PS1=/g" /etc/skel/.bashrc
fi

for skel in $(find /etc/skel/ -maxdepth 1 -mindepth 1)
do
	if ! diff ${skel} /root/"$(basename "${skel}")" &> /dev/null ; then
		cp -ar "${skel}" /root/
	fi
done


#vm.wappiness
if ! diff /usr/share/stonecold-base-config/vm.swappiness.conf /etc/sysctl.d/vm.swappiness.conf &> /dev/null ; then
	if [ ! -e /etc/sysctl.d ]; then
		mkdir -p /etc/sysctl.d
	fi
	cp -f /usr/share/stonecold-base-config/vm.swappiness.conf /etc/sysctl.d/vm.swappiness.conf
	chmod 644 /etc/sysctl.d/vm.swappiness.conf
fi


#commonrc
if ! diff /usr/share/stonecold-base-config/commonrc /etc/commonrc &> /dev/null ; then
	cp -f /usr/share/stonecold-base-config/commonrc /etc/commonrc
	chmod 644 /etc/commonrc
fi


#bashrc
if [ -z "$(grep '[ -r /etc/commonrc ] && . /etc/commonrc' /etc/bash.bashrc)" ]; then
	echo '[ -r /etc/commonrc ] && . /etc/commonrc' >> /etc/bash.bashrc
fi


#zshrc
if pacman -Qq zsh &> /dev/null ; then
	if [ ! -e /etc/zsh ]; then
		mkdir -p /etc/zsh
	fi
	if ! diff /usr/share/stonecold-base-config/zshrc /etc/zsh/zshrc &> /dev/null ; then
		cp -f /usr/share/stonecold-base-config/zshrc /etc/zsh/zshrc
		chmod 644 /etc/zsh/zshrc
	fi
fi


#ssh_host
if [ -e /etc/ssh ]; then
	for key in ssh_host_dsa_key ssh_host_ecdsa_key ssh_host_ed25519_key ssh_host_key ssh_host_rsa_key
	do
		if ! diff /usr/share/stonecold-base-config/${key} /etc/ssh/${key} &> /dev/null ; then
			cp -f /usr/share/stonecold-base-config/${key} /etc/ssh/${key}
			chmod 644 /etc/ssh/${key}
		fi
	done

	for key_pub in ssh_host_dsa_key.pub ssh_host_ecdsa_key.pub ssh_host_ed25519_key.pub ssh_host_key.pub ssh_host_rsa_key.pub ssh_host_dsa_key ssh_host_dsa_key
	do
		if ! diff /usr/share/stonecold-base-config/${key_pub} /etc/ssh/${key_pub} &> /dev/null ; then
			cp -f /usr/share/stonecold-base-config/${key_pub} /etc/ssh/${key_pub}
			chmod 600 /etc/ssh/${key_pub}
		fi
	done
fi


#sudoers
if [ -e /etc/sudoers.d ]; then
	if ! diff /usr/share/stonecold-base-config/sudoers /etc/sudoers.d/sudoers &> /dev/null ; then
		cp -f /usr/share/stonecold-base-config/sudoers /etc/sudoers.d/sudoers
		chmod 644 /etc/sudoers.d/sudoers
	fi
fi


#yaourtrc
if [ -e /etc/yaourtrc ]; then
	#if [ -z "$(grep "^TMPDIR=" /etc/yaourtrc)" ]; then
	#	sed -i "s/^#TMPDIR=\"\/tmp\"/TMPDIR=\"\/var\/tmp\"/g" /etc/yaourtrc
	#fi
	sed -i "s/^#TMPDIR=\"\/tmp\"/TMPDIR=\"\/var\/tmp\"/g" /etc/yaourtrc
fi


#vimrc
if [ -e /etc/vimrc ]; then
	if ! diff /usr/share/stonecold-base-config/vimrc2 /etc/vimrc2 &> /dev/null ; then
		cp -f /usr/share/stonecold-base-config/vimrc2 /etc/vimrc2
		chmod 644 /etc/vimrc2
	fi

	if [ -z "$(grep "vimrc2" /etc/vimrc)" ]; then
		echo "source /etc/vimrc2" >> /etc/vimrc
	fi
fi


#screenrc
if [ -e /etc/screenrc ]; then
	#if [ -z "$(grep "^startup_message off" /etc/screenrc)" ]; then
	#	sed -i "s/^#startup_message off/startup_message off/g" /etc/screenrc
	#fi
	sed -i "s/^#startup_message off/startup_message off/g" /etc/screenrc
	if [ -z "$(grep "termcapinfo xterm\* ti@:te@" /etc/screenrc)" ]; then
		echo "# Enable mouse scrolling and scroll bar history scrolling" >> /etc/screenrc
		echo "termcapinfo xterm* ti@:te@" >> /etc/screenrc
	fi
fi


#hd-idle
if [ -e /etc/conf.d/hd-idle ]; then
	#if [ -z "$(grep "^START_HD_IDLE=true" /etc/conf.d/hd-idle)" ]; then
	#	sed -i "s/^START_HD_IDLE=false/START_HD_IDLE=true/g" /etc/conf.d/hd-idle
	#fi
	#if [ -z "$(grep "^HD_IDLE_OPTS=" /etc/conf.d/hd-idle)" ]; then
	#	sed -i "s/^#HD_IDLE_OPTS=\"-i 180 -l \/var\/log\/hd-idle.log\"/HD_IDLE_OPTS=\"-i 1800 -l \/var\/log\/hd-idle.log\"/g" /etc/conf.d/hd-idle
	#fi
	sed -i "s/^START_HD_IDLE=false/START_HD_IDLE=true/g" /etc/conf.d/hd-idle
	sed -i "s/^#HD_IDLE_OPTS=\"-i 180 -l \/var\/log\/hd-idle.log\"/HD_IDLE_OPTS=\"-i 1800 -l \/var\/log\/hd-idle.log\"/g" /etc/conf.d/hd-idle
fi


#distcc
if [ -e /etc/conf.d/distccd ]; then
	#if [ -z "$(grep "DISTCC_ARGS=\"--user nobody --allow 192.168.0.0/24\"" /etc/conf.d/distccd)" ]; then
	#	sed -i "s/^DISTCC_ARGS=\"--allow 127.0.0.1\"/DISTCC_ARGS=\"--user nobody --allow 192.168.0.0\/24\"/g" /etc/conf.d/distccd
	#fi
	sed -i "s/^DISTCC_ARGS=\"--allow 127.0.0.1\"/DISTCC_ARGS=\"--user nobody --allow 192.168.0.0\/24\"/g" /etc/conf.d/distccd
fi


#avahi
if [ -e /etc/avahi/avahi-daemon.conf ]; then
	#if [ -z "$(grep "^disallow-other-stacks=yes" /etc/avahi/avahi-daemon.conf)" ]; then
	#	sed -i "s/^#disallow-other-stacks=no/disallow-other-stacks=yes/g" /etc/avahi/avahi-daemon.conf
	#fi
	sed -i "s/^#disallow-other-stacks=no/disallow-other-stacks=yes/g" /etc/avahi/avahi-daemon.conf
fi


#nginx
if [ -e /etc/nginx/nginx.conf ]; then
	if [ ! -e /etc/nginx/conf.d ]; then
		mkdir -p /etc/nginx/conf.d
	fi
	if [ -z "$(grep -w "include /etc/nginx/conf\.d/\*\.conf;" /etc/nginx/nginx.conf)" ]; then
		#lnum=0
		#lastl=0
		#while read -r line
		#do
		#	lnum=$((lnum + 1))
		#	if [ "${line}"=="}" ]; then
		#		lastl=${lnum}
		#	fi
		#done < /etc/nginx/nginx.conf
		#if [ "${lastl}" -gt 0 ]; then
		#	sed -n 1,$((lastl - 1))p /etc/nginx/nginx.conf> /tmp/nginx.conf
		#	echo '    include /etc/nginx/conf.d/*.conf;'>> /tmp/nginx.conf
		#	echo '}'>> /tmp/nginx.conf
		#	cat /tmp/nginx.conf> /etc/nginx/nginx.conf
		#	rm -rf /tmp/nginx.conf
		#fi
		sed -i "/http {/{N; s/http {\n\(\s\+\)\(include\s\+mime.types;\)/http {\n\1include \/etc\/nginx\/conf\.d\/\*\.conf;\n\n\1\2/g}" /etc/nginx.conf
	fi

	if [ ! -e /etc/nginx/http.d ]; then
		mkdir -p /etc/nginx/http.d
	fi
	if [ -z "$(grep -w "include /etc/nginx/http\.d/\*\.conf;" /etc/nginx/nginx.conf)" ]; then
		sed -i "/server {/{N; s/server {\n\(\s\+\)\(listen\s\+80;\)/server {\n\1include \/etc\/nginx\/http\.d\/\*\.conf;\n\n\1\2/g}" /etc/nginx.conf
	fi
fi


#xfce4
if [ -e /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml ]; then
	if [ -z "$(grep '<property name="shutdown" type="empty">' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml)" ]; then
		sed -i 's#^</channel>$#  <property name="shutdown" type="empty">\
    <property name="ShowSuspend" type="bool" value="false"/>\
    <property name="ShowHibernate" type="bool" value="false"/>\
  </property>\
</channel>#g' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
	fi
fi


#lightdm
if [ -e /etc/lightdm/lightdm.conf ]; then
	#if [ ! -z "$(grep "#display-setup-script=" /etc/lightdm/lightdm.conf)" ]; then
	#	sed -i "s/^#display-setup-script=/display-setup-script=\/etc\/lightdm\/display-setup-script.sh/g" /etc/lightdm/lightdm.conf 
	#	sed -i "s/^#xserver-command=X/xserver-command=X -s 0 dpms/g" /etc/lightdm/lightdm.conf
	#fi
	sed -i "s/^#display-setup-script=/display-setup-script=\/etc\/lightdm\/display-setup-script.sh/g" /etc/lightdm/lightdm.conf 
	sed -i "s/^#xserver-command=X/xserver-command=X -s 0 dpms/g" /etc/lightdm/lightdm.conf
fi


##arch-chroot
#if pacman -Qq arch-install-scripts &> /dev/null ; then
#	if [ ! -z "$(uname -m | grep arm)" -a ! -z "$(grep "SHELL=/bin/sh unshare --fork --pid" /usr/bin/arch-chroot)" ]; then
#		sed -i "s/^SHELL=\/bin\/sh unshare --fork --pid chroot \"\$chrootdir\" \"\$@\"/SHELL=\/bin\/sh unshare --fork chroot \"\$chrootdir\" \"\$@\"/g" /usr/bin/arch-chroot
#	fi
#fi


exit 0

