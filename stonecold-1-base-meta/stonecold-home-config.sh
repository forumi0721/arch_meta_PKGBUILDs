#!/bin/sh

#ssh
mkdir -p ~/.ssh
chmod 700 ~/.ssh

cat << 'EOF' > ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp6N0kMQTJVy9PFKzNoxGb4Ti9J12EHlAJfo18rxt8dChd6GffjZL3TRx419fKR+AkJjaRn6TSVYa0UBnVTnfKzKYDQfkAr4R24cb/Kh24V2pZqmqvX/OD59I1kKVJmzHUCSH2+jxo4H6mSL3iu38Th6vewLe9yPyQXgJZKuA7/MduAc6fQzvldUjXwZmzV+lKt5Re/6k6LVD25+Y/HnNrRHoJnCFoGv3hkLqb1UYiOP2gWiLVEPJjJ8Fu+vMckkUpbxMwsff0J+fOPzpRNC0MQBvn+/SveoZb7QOyAZkKxL9dxKErvbuxYNHckF1XtK/mJ5Qoki0FO4p8uw9CfDjv root@StoneCold
EOF
chmod 644 ~/.ssh/authorized_keys

cat << 'EOF' > ~/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEpgIBAAKCAQEAqejdJDEEyVcvTxSszaMRm+E4vSddhB5QCX6NfK8bfHQoXehn
342S900ceNfXykfgJCY2kZ+k0lWGtFAZ1U53ysymA0H5AK+EduHG/yoduFdqWapq
r1/zg+fSNZClSZsx1Akh9vo8aOB+pki94rt/E4er3sC3vcj8kF4CWSrgO/zHbgHO
n0M75XVI18GZs1fpSreUXv+pOi1Q9ufmPx5za0R6CZwhaBr94ZC6m9VGIjj9oFoi
1RDyYyfBbvrzHJJFKW8TMLH39Cfnzj86UTQtDEAb5/v0r3qGW+0DsgGZCsS/XcSh
K727sWDR3JBdV7Sv5ieUKJItBTuKfLsPQnw47wIDAQABAoIBAQCohxyxhR1mR1/Z
ZHxyC0iwAJiypZUQMrDYefoErfrpWp2fZ6GAD4CyYn3XLuAO93PO50hA8MQfDE3s
E3dMJ+SR9qLDoHBGydDtycwD09ZevfXysiHXiaiUMSBDmREZDSJDWjuiKVo5/FIi
xQvzFF5bFLrY2vZk/DHnUBesMebwF4/bRWwag7I3R/05FuH88yxU/GZGBAgx7zVi
WagbTQam1ns6YU7c3vck2gpRFa4Y7n/HLbIU/DIvUJiydw5yxBfOBWnTZ8JfpV9G
Dgur9iYzVS9hScUWxHyp6ePpGmjXQTlaeChAbIZvG8+MmVlAAvHq/KFYZE7Xu4aR
xbQWyxahAoGBANpu5xqFHXaVNNpbglHsJkRVPEp134YKkTSJn+qTW3z+Y6WihhrR
10BzxZUgJ6+IY2Xq69pthKTxC8xcGXxt6HlDOse6Z6onsBwm0MOgPiHwhGIsrK/K
EAoQHLJq5U6XncNwA7QJAqrxSpn4jAAzkfC6rrPpOMS4Jx7g9RjqP+QrAoGBAMch
lRMHey4S+uV6c3EZOvcL6Sr+divDd/oENpkV7nbf8tO817PUGmuL0Fkf3s2xtp6i
JLpJh6SXs0uPjMnNk378QOXON3DR1zcHJApNtffKGrRlwFFy9xECdVJaWfSnMRBE
U1KlGTWI5UeIHHllfl+nCx/WedBpZOSJyE1YichNAoGBALi3gm211iWapdhl/D3F
AtNUdSjOp1iWBRc1rutS89Iu2huO5fM2Mt5JSPQD/it9nfjpAcx0QvCs+vo1hEPq
OeaaCNIv+0w0RcR4uqBEGWbgG0NeXiZGLOwlle73YLTmmD5WsnsEB6KBbEHqopHl
CmxVojl4Z05MIKEHQZ1xMtiDAoGBAMTJ3UbG9+aafzRVBMzaQDlwnecNPb8WFvUP
QN2cnOMBgjnZv9lJXSq3KxlIs6jXXT/7wQwQKmpwOJINtPahoIe3xnLUjlmCJouN
FQLRtWjBZA6vF5XmZV977HGMNKXgrE4FF8ruubD8Lom4a1tU/8SLkiTOkedyoHBx
8W7udotpAoGBAKB0ne5fhCnZRxkUdlWoYOKJumKsJahZdfSCBTx7o3RkfUcwrGiZ
6QOQqgXce6Wr6WOYBFxQQVqcvgbT1GR/tOg1hB7MuamQnBJwZckIPeXtVmDEP2ry
wudlQ4kGxfIKJuo77JJbzt8jR2SojAvu05fJ+JvVYcwSv67n26g/4uqc
-----END RSA PRIVATE KEY-----
EOF
chmod 600 ~/.ssh/id_rsa

cat << 'EOF' > ~/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp6N0kMQTJVy9PFKzNoxGb4Ti9J12EHlAJfo18rxt8dChd6GffjZL3TRx419fKR+AkJjaRn6TSVYa0UBnVTnfKzKYDQfkAr4R24cb/Kh24V2pZqmqvX/OD59I1kKVJmzHUCSH2+jxo4H6mSL3iu38Th6vewLe9yPyQXgJZKuA7/MduAc6fQzvldUjXwZmzV+lKt5Re/6k6LVD25+Y/HnNrRHoJnCFoGv3hkLqb1UYiOP2gWiLVEPJjJ8Fu+vMckkUpbxMwsff0J+fOPzpRNC0MQBvn+/SveoZb7QOyAZkKxL9dxKErvbuxYNHckF1XtK/mJ5Qoki0FO4p8uw9CfDjv root@StoneCold
EOF
chmod 644 ~/.ssh/id_rsa.pub

#git
cat << 'EOF' > ~/.gitconfig
[user]
	email = forumi0721@gmail.com
	name = forumi0721
[push]
	default = simple
EOF
chmod 644 ~/.gitconfig

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

if [ -e /usr/bin/nabi ]; then
	export XIM=nabi
	export XIM_PROGRAM=/usr/bin/nabi
	export XIM_ARGS=
	export XMODIFIERS="@im=nabi"
	export GTK_IM_MODULE=xim
	export QT_IM_MODULE=xim
	/usr/bin/nabi &
fi

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


exit 0

