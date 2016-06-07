#!/bin/sh

#ssh
mkdir -p ~/.ssh
chmod 700 ~/.ssh

cat << 'EOF' > ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWDwbsVEr158UD68Ub4mYM/CzWudN0v4y6tOmq/SsjaYJqRTK6b2Vj3yNUK3aKGitQkk5ZSmLkPxFlZSI5DQ/DA3/rkiwZ/DWyUgKUvEHBynkRIeDbJg+VAHgI5c2gvuTAiNOL373HyGUd7zshYr5lsRDOEuoXuQV+3iZ/o0mZLF4TNYIFPv2Xz+fkUoZ6WlNnWhwkofhvWl83TrbziahoDbafW7vPSzNNo+tDms+DpNKa2b9XiVBLTV6z/Ovv1xqpOA3eUMyCCG/l6gjOEIsk3/rAjZ13is0/nSIbWaIK1yBuAjAUBMPvNG35Ydp413OP3Rz5uUXZb/+RwQ99M1Cz StoneCold
EOF
chmod 644 ~/.ssh/authorized_keys

cat << 'EOF' > ~/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA1g8G7FRK9efFA+vFG+JmDPws1rnTdL+MurTpqv0rI2mCakUy
um9lY98jVCt2ihorUJJOWUpi5D8RZWUiOQ0PwwN/65IsGfw1slIClLxBwcp5ESHg
2yYPlQB4COXNoL7kwIjTi9+9x8hlHe87IWK+ZbEQzhLqF7kFft4mf6NJmSxeEzWC
BT79l8/n5FKGelpTZ1ocJKH4b1pfN06284moaA22n1u7z0szTaPrQ5rPg6TSmtm/
V4lQS01es/zr79caqTgN3lDMgghv5eoIzhCLJN/6wI2dd4rNP50iG1miCtcgbgIw
FATD7zRt+WHaeNdzj90c+blF2W//kcEPfTNQswIDAQABAoIBAQDGV3QtxMkUY2X9
BRhFhxjSDVOqvtJ9CgPm+DzPb/fpvxjVSTsA3rkOujItCnyy6B6ccIRiXfeV0A5Z
akU0obKqGvMLnwx4I2bJzQ2RLYKsguR9CGwmA3VKtf2DGRPYTyj8cYu6vl1F4Zw4
CXQ7shgDd/a/S21W/9xkuojnmbBXWL8rUG3cni3AqTH3gCQOGe6jsHneLxUyo/cd
Hq0dcEb+1wDidpIc+63j7ueqdDM+8PDeJiNYN2Up0g84eRBuYOiR+xcyS0Ofi1Qm
UWIzmwSaeVYsN94Evq99e3kglwbqJVwK0oz2828evCfi87ZPhufRf6Zwk6SgFwAM
ONWNGMChAoGBAPoWkUMYrh8GoAkbtSEhhdSV4nnmy7siPQ6ExXQ2Shyi99J6f/VN
ftxzgrTiGcRmRIwlQwG+67UPs8EjgfXtrF9xeCNBPE7j7XcmnPV5izqLFjavHJRe
DToTe2OsH11xA80Ec15iXiiomzu6KKl8dYoEN6sADbDFoJjsltAKLS0RAoGBANse
bIRyCArOwgXLBYSM/+5dHfND2UTaTpO3+sSleV33KxjyvXHu2OcVB0zPra5IqqVK
rl80XNAyw1E5R/FRlvujhZ3OPwGziuNKbAmvQ2r+SpQzT36Fl2hqcL54317dN4l9
rD7r2wzFVr/lGe490WzcBXZ+Ww1732uOOTovJTGDAoGATxMnpyF8nM7Jd1fNc8ZX
vJoP3B9/t5Hh4F9W16H62QcmeOTG5Nc2D5pub6c2IoV7kxyNDVZCzSND4QPLKemW
oS8Nn4gW+5LSGOSaqHtf7Ijh4zSHQtpiMETMtP1NhYwgeYi4udU8lHqLat030i9K
MvOWbnk72vMCDphwLyOomSECgYAM/GSaBNgNK+u7xChzjpesXMBlpmO9/OIjRwgJ
l3T16KwZMmmf0vPv3gMsvjIg3hWe7iofYk8N17RTn/1vg9Ja33oPvCVnyGg2yDZW
7JgmQyPQXKodaXVrrsM3xpoWWS3tbBFFOV0mCJv3i3BZ+jfrJ677Msnapri6+xbR
J/IgWQKBgHaYE5MGffPjmeCdsBHEaq91Lgtzwx22lhturNIojXC+DrMTPPQ4oqE6
SdcJm9zZeCxtnB3z6b3TrJRKqcE3dZ4sdEH6DcLclMyqiXncDuOdwUKihCtEhQWx
5O6J8sboQgSLj3Gee8aGtbKR9RSwj/LZEumCxm7yXd8Su0r0UtcQ
-----END RSA PRIVATE KEY-----
EOF
chmod 600 ~/.ssh/id_rsa

cat << 'EOF' > ~/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWDwbsVEr158UD68Ub4mYM/CzWudN0v4y6tOmq/SsjaYJqRTK6b2Vj3yNUK3aKGitQkk5ZSmLkPxFlZSI5DQ/DA3/rkiwZ/DWyUgKUvEHBynkRIeDbJg+VAHgI5c2gvuTAiNOL373HyGUd7zshYr5lsRDOEuoXuQV+3iZ/o0mZLF4TNYIFPv2Xz+fkUoZ6WlNnWhwkofhvWl83TrbziahoDbafW7vPSzNNo+tDms+DpNKa2b9XiVBLTV6z/Ovv1xqpOA3eUMyCCG/l6gjOEIsk3/rAjZ13is0/nSIbWaIK1yBuAjAUBMPvNG35Ydp413OP3Rz5uUXZb/+RwQ99M1Cz StoneCold
EOF
chmod 644 ~/.ssh/id_rsa.pub

cat << 'EOF' > ~/.ssh/id_rsa_aur
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEA0FgOtqWh2/MN4a9DV0MvYRBDcNpyL77F7l1BsDXVyeg6iQBM
0Vex3lfTxRNyorGIIz6310Uo2Th+D8ZEdXZxVxCI52aSmLWfPQnKmMI2bCM3aydm
YvjinGqK36eL5TVHfgVFBalYth3YMLbg94i7LQxmlXmupoERHLucFy8VGw7u95Ep
Ayirw+mx68QPA8Zxspipv22NBdPIyz4bxESYdFQ2De2t/VOlpEBudUT7MwIY92qv
mvORApNDIW0s8P3bjhrMXipEe03Gnw5Vyj6vzGnTyKJ2N66OIcMudYrMmG6YHq1F
gfHgkuxBhaBs+rsxwv8AUqxTbbYDki1tVRck9wIDAQABAoIBADD5EfRS+LoH5vJu
zSh87W0mcoPbhU29zS7bku5FqUw9n0zG2ke3EmNOR8QibybZDkQioPokEpcE1XUF
yN/HiJrLkzK5hKoKvzSM0aeYt0wx9vvkFggbssDLtnseGh81p+lyeaf8B5M/bqr8
weLNrBnJuW9XW/tdiVU0sFsuwQpLyq8VpLSVjxAISQV9O2BzqhIP4Tv3r8SJnczr
MKCF7r7VQ8TxcwqO6FzdXXUl0tyL+goQqU7ZL7QyGi9J24zPjPvqxCXkZ+KxoPUo
kGi5l1WCJy+DxlqRocjw3GrjrHfyDuMe+Mco+IxhHhdiTJ88IMAYE9++TaI7nyY4
vW7RwaECgYEA7/l8iFE/cHj9YLbGLOgFQ8fTS8FRVhnIEHH+P0CNtgLt2UsJjc8r
LeDKMuujh47yZdPh9GOKvC9dCLHgDU7nY+I/65oCYIXbMV750zdYyUFQfwOQuzGA
zvAo89tjZK4+SOUwxxk8cbFkJ+6NtE+jDA38ThxyCc6yUsdWTAzJC7ECgYEA3kHT
nyVNS1o49Vz4awu78+AA2seSQadOs5qGaYoaXzb0SVkY8Bq3RHe0emlal63aHRgn
4CIUlettbUfAIHg1cmEHQ3dSWmS6yz7kPfQQOb94geSk4o13RommgO8A+qytQ0o0
0nXoVr7wRS/3+6FCuQnU4YJzkEFZ6joIeXs8bScCgYARaUWa0mJK88xWfwxj57Wy
FEaFYZJYL+ivIMY0qqddhFrjgClCS7yzSHMDPMuRo1J9BuGHDM3dF4algdpivM3X
FmxS2MrBXBTqQRzZMVPUzlNb09NlcZMJ8KzX/Jv6ixXjzhU67N7Q1PESYKGRapHG
5yDePfwcMA4KKYJeZDMWEQKBgBUF1vWLurbw7shOpfTCJGIaAxqum+f34lrct/AN
rxbohMzXT6OOc11XkUuu4XHNcP8lhMgPkTDpFu2qRsMLe8q44M4B4FlKg9yrsz0k
88/yi3yF2w7O4MRcStKRSN9tK+pcf4iUvIhQATwaIHO9uij0hB1ckH/Jnq6oFJsh
DAMrAoGAQtI9oNdF7SeXDIE5dWpEGty/ullMKjRQUWMkEQ04yHeD66zBIlNjT7gK
/5uTjz9Wqdcf5D3oWioPx4VkIEyyzwAbKmr5sp0f4EnbyL+/gUvwEGXH04HtjTLa
PHvSLPPWXVk353qEo0Zp0sINixCLinR6q+U7t8XEkBJjiENveZU=
-----END RSA PRIVATE KEY-----
EOF
chmod 600 ~/.ssh/id_rsa_aur

cat << 'EOF' > ~/.ssh/id_rsa_aur.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQWA62paHb8w3hr0NXQy9hEENw2nIvvsXuXUGwNdXJ6DqJAEzRV7HeV9PFE3KisYgjPrfXRSjZOH4PxkR1dnFXEIjnZpKYtZ89CcqYwjZsIzdrJ2Zi+OKcaorfp4vlNUd+BUUFqVi2HdgwtuD3iLstDGaVea6mgREcu5wXLxUbDu73kSkDKKvD6bHrxA8DxnGymKm/bY0F08jLPhvERJh0VDYN7a39U6WkQG51RPszAhj3aq+a85ECk0MhbSzw/duOGsxeKkR7TcafDlXKPq/MadPIonY3ro4hwy51isyYbpgerUWB8eCS7EGFoGz6uzHC/wBSrFNttgOSLW1VFyT3 StoneCold
EOF
chmod 644 ~/.ssh/id_rsa_aur.pub

cat << 'EOF' > ~/.ssh/config
Host aur4.archlinux.org aur.archlinux.org
  User aur
  IdentitiesOnly yes
  IdentityFile ~/.ssh/id_rsa_aur
EOF
chmod 644 ~/.ssh/config

#git
cat << 'EOF' > ~/.gitconfig
[user]
	email = forumi0721@gmail.com
	name = forumi0721
[push]
	default = simple
[color]
	ui = auto
EOF
chmod 644 ~/.gitconfig

#.xprofile
cat << 'EOF' > ~/.xprofile
#!/bin/sh

xmodmap -e 'remove mod1 = Alt_R'
xmodmap -e 'keycode 108 = Hangul'
xmodmap -e 'remove control = Control_R'
xmodmap -e 'keycode 105 = Hangul_Hanja'

if [ -e /usr/bin/nabi ]; then
	export XIM=nabi
	export XIM_PROGRAM=/usr/bin/nabi
	export XIM_ARGS=
	export XMODIFIERS="@im=nabi"
	export GTK_IM_MODULE=xim
	export QT_IM_MODULE=xim
	/usr/bin/nabi &
elif [ -e /usr/bin/fcitx ]; then
	export XMODIFIERS=@im=fcitx
	export GTK_IM_MODULE=fcitx
	export QT_IM_MODULE=fcitx
elif [ -e /usr/bin/ibus ]; then
	export XMODIFIERS=@im=ibus
	export GTK_IM_MODULE=ibus
	export QT_IM_MODULE=ibus
fi
EOF
chmod 644 ~/.xprofile

#vncserver
mkdir -p ~/.vnc
cat << 'EOF' | xxd -r -ps > ~/.vnc/passwd
d58c476d039c3dc4
EOF
chmod 600 ~/.vnc/passwd

cat << 'EOF' > ~/.vnc/xstartup
#!/bin/sh

#unset SESSION_MANAGER
#unset DBUS_SESSION_BUS_ADDRESS
#OS=`uname -s`
#if [ $OS = 'Linux' ]; then
#  case "$WINDOWMANAGER" in
#    *gnome*)
#      if [ -e /etc/SuSE-release ]; then
#        PATH=$PATH:/opt/gnome/bin
#        export PATH
#      fi
#      ;;
#  esac
#fi
#if [ -x /etc/X11/xinit/xinitrc ]; then
#  exec /etc/X11/xinit/xinitrc
#fi
#if [ -f /etc/X11/xinit/xinitrc ]; then
#  exec sh /etc/X11/xinit/xinitrc
#fi
#[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
#xsetroot -solid grey
#xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
#twm &

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

export LANG=ko_KR.UTF-8
export XKL_XMODMAP_DISABLE=1

vncconfig -nowin&

exec startxfce4
EOF
chmod 755 ~/.vnc/xstartup

#skel
for skel in $(find /etc/skel/ -maxdepth 1 -mindepth 1)
do
	if [ ! -e ~/"$(basename "${skel}")" ]; then
		cp -ar "${skel}" ~/
	fi
done
sed -i "s/^alias ls=/#^alias ls=/g" ~/.bashrc
sed -i "s/^PS1=/#PS1=/g" ~/.bashrc

#.zshrc
touch ~/.zshrc

#.bash_history
ln -sf /dev/null ~/.bash_history

exit 0

