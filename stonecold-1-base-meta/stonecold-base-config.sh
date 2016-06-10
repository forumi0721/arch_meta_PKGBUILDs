#!/bin/sh

if [ "${EUID}" != "0" ]; then
	sudo "${0}" $@
	exit $?
fi

#commonrc
cat << 'EOF' > /etc/commonrc
#!/bin/sh

#Shell
SH=
#if [ ! -z "$(set | grep BASH)" -o "${SHELL/bash/}" != "${SHELL}" ]; then
#   SH=bash
#elif [ ! -z "$(set | grep ZSH)" -o "${SHELL/zsh/}" != "${SHELL}" ]; then
#   SH=zsh
#fi
if ! shopt &> /dev/null ; then
	SH=zsh
else
	SH=bash
fi

# "Command not found" hook
if [ ! -z "${TERM}" -a "${TERM}" != "dumb" -a \( "$(uname -m)" = "x86_64" -o "$(uname -m)" = "x86" \) ]; then
	if [ "${SH}" = "bash" -a -e /usr/share/doc/pkgfile/command-not-found.bash ]; then
		source /usr/share/doc/pkgfile/command-not-found.bash
	elif [ "${SH}" = "zsh" -a -e /usr/share/doc/pkgfile/command-not-found.zsh ]; then
		source /usr/share/doc/pkgfile/command-not-found.zsh
	fi
fi

#Color
export CLICOLOR=1

#Prompt
if [ "${CLICOLOR}" = "1" ]; then
	if [ "${SH}" = "bash" ]; then
		if [ "${EUID}" = "0" ]; then
			export PS1='\[\033[01;31m\]\u@\h\[\033[01;34m\] \W \$\[\033[00m\] '
		else
			export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
		fi	  
	fi
	export LSCOLORS=ExFxBxDxCxegedabagacad
	alias ls="ls --color=auto"
	alias grep="grep --color=auto"
	alias egrep="grep --color=auto"
	alias fgrep="grep --color=auto"
fi

# aliases
alias sudo='sudo '
alias cls='clear'
alias l='ls'
alias la='ls -la'
alias ll='ls -l'
alias df='df -h'
alias du='du -h'
alias vi='vim'
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias cps='sudo cp'
alias mvs='sudo mv'
alias rms='sudo rm'
alias lns='sudo ln'
alias mds='sudo mkdir'
alias vis='sudo vi'
if [ "${UID}" != "0" ]; then
	alias poweroff='sudo poweroff'
	alias halt='sudo poweroff'
	alias shutdown='sudo shutdown'
	alias reboot='sudo reboot'
	alias dmesg="sudo dmesg"

	alias mount='sudo mount'
	alias umount='sudo umount'
	alias su='sudo su'

	alias pacman='sudo pacman'
	alias abs='sudo abs'
	alias pkgfile='sudo pkgfile'
	alias systemctl='sudo systemctl'
	alias journalctl='sudo journalctl'
	alias iotop='sudo iotop'
	alias lsof='sudo lsof'
fi

#Environment Setting
export VISUAL="vi"
export EDITOR="vi"
export SVN_MERGE="vi -d"
export PAGER="less"
export LESSHISTFILE=/dev/null

#Path
if [ -e ~/.bin2 ]; then
    export PATH=~/.bin2:${PATH}
fi
if [ -e ~/.bin ]; then
    export PATH=~/.bin:${PATH}
fi

#Term
if [ "${TERM}" = "vt220" ]; then
	export TERM=linux
fi


#functions
pbcopy() {
	local cb=/tmp/clipboard
	if [ -e ${cb}.lock ]; then
		echo "Clipboard locked"
		return
	fi
	touch ${cb}.lock
	chmod 777 ${cb}.lock
	rm -rf ${cb}
	while read data; do
		echo "${data}" >> ${cb}
	done
	chmod 777 ${cb}
	rm -rf ${cb}.lock
}

pbpaste() {
	local cb=/tmp/clipboard
	if [ -e ${cb}.lock ]; then
		return
	fi
	if [ ! -e ${cb} ]; then
		return
	fi
	touch ${cb}.lock
	cat ${cb}
	rm -rf ${cb}.lock
}

mk() {
	if [ -x /usr/bin/makepkg ]; then
		BUILDDIR=/var/tmp/makepkg makepkg -cCrs --noconfirm --skippgpcheck "$@"
	else
		echo "command not found: makepkg"
	fi
}

unset SH

[ -r /etc/commonrc2  ] && . /etc/commonrc2

EOF
chmod 644 /etc/commonrc

if [ -z "$(grep '[ -r /etc/commonrc  ] && . /etc/commonrc' /etc/bash.bashrc)" ]; then
	echo '[ -r /etc/commonrc  ] && . /etc/commonrc' >> /etc/bash.bashrc
fi

if [ ! -e /etc/zsh ]; then
	mkdir -p /etc/zsh
fi
cat << 'EOF' > /etc/zsh/zshrc
# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gentoo"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(git)
plugins=(git colored-man colorize github vagrant virtualenv pip python zsh-syntax-highlighting gnu-utils svn screen)

# User configuration

#export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"


# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump"

source $ZSH/oh-my-zsh.sh

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#bindkey -e  
bindkey '[C' forward-word  
bindkey '[D' backward-word  

[ -e /etc/commonrc ] && . /etc/commonrc

EOF
chmod 644 /etc/zsh/zshrc

#locale
cat << 'EOF' > /etc/locale.conf
if [ -z "${TERM}" -o "${TERM}" = "linux" -o "${TERM}" = "vt220" -o "${TERM}" = "dumb" ]; then
	LANG=C
	LC_COLLATE=C
	LC_CTYPE=C
else
	LANG=ko_KR.UTF-8
	LC_COLLATE=ko_KR.UTF-8
	LC_CTYPE=ko_KR.UTF-8
fi
EOF
chmod 644 /etc/locale.conf

#ssh_host
cat << 'EOF' > /etc/ssh/ssh_host_dsa_key
-----BEGIN DSA PRIVATE KEY-----
MIIBugIBAAKBgQDEqGPKnIv/NNUTrwaZ2jNxz5tJyY1kXr0JJ/gzTrvc38n1PUXV
CCyybB9YdzPkQiD4Y9svUgJPTlQRqF+KEfkTqTTlHkbLHjhZ08lDN1iXRjqLJe7n
LHEEHYDB3zdcY9TlKsfgREgOU8KLd7Sf0zEpIwisErzIwc6s1zl2m8hXcwIVALTf
9ze5nPtFmOoXxx4a8Cco1XDrAoGALMc5xB965GrqYrb8pJrcBc5zZ1aRQYkK2xgK
0edrYKeTivhNpsFaKxVKC9XFRuDJrYld28Wmpcf0+zM5nI0AOgJSU7AfYIlhWbCC
EofHxKvqQ4PfWZYVLUraluezeWVno+WFXFGki3XIAizzl1qHiq660UhwIdtu+edh
rzVptmcCgYADPWtjSKD+LsPBypOAq4XWg8g2xuqulPOIecxRfLIpsOy78wTCI5tj
aRZe/uRHMyZeYXH+jInmoRG7WLuqej4c3V85T/7a4dAgVrc52Uve4UuLSlA83i71
+WESzpPGDUWwSmkcUA+EuTDf9YGuqJ20l6wpH9rojd7Om81m2yIJOgIURizsvWQ2
d7kOSM7q8ljtUHaW0HI=
-----END DSA PRIVATE KEY-----
EOF
chmod 600 /etc/ssh/ssh_host_dsa_key

cat << 'EOF' > /etc/ssh/ssh_host_dsa_key.pub
ssh-dss AAAAB3NzaC1kc3MAAACBAMSoY8qci/801ROvBpnaM3HPm0nJjWRevQkn+DNOu9zfyfU9RdUILLJsH1h3M+RCIPhj2y9SAk9OVBGoX4oR+ROpNOUeRsseOFnTyUM3WJdGOosl7ucscQQdgMHfN1xj1OUqx+BESA5Twot3tJ/TMSkjCKwSvMjBzqzXOXabyFdzAAAAFQC03/c3uZz7RZjqF8ceGvAnKNVw6wAAAIAsxznEH3rkaupitvykmtwFznNnVpFBiQrbGArR52tgp5OK+E2mwVorFUoL1cVG4MmtiV3bxaalx/T7MzmcjQA6AlJTsB9giWFZsIISh8fEq+pDg99ZlhUtStqW57N5ZWej5YVcUaSLdcgCLPOXWoeKrrrRSHAh227552GvNWm2ZwAAAIADPWtjSKD+LsPBypOAq4XWg8g2xuqulPOIecxRfLIpsOy78wTCI5tjaRZe/uRHMyZeYXH+jInmoRG7WLuqej4c3V85T/7a4dAgVrc52Uve4UuLSlA83i71+WESzpPGDUWwSmkcUA+EuTDf9YGuqJ20l6wpH9rojd7Om81m2yIJOg== StoneCold
EOF
chmod 644 /etc/ssh/ssh_host_dsa_key.pub

cat << 'EOF' > /etc/ssh/ssh_host_ecdsa_key
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIGicG5LbRhXCEvJ7o5jslPiBQ0ldpr/FqJD16pvSqHJcoAoGCCqGSM49
AwEHoUQDQgAE2TGNClMspFP86S1PHJ4fTHGIQnugL5hUcRNb5Bn+iQIZ+xiQebyD
l6oVGGxzvfB5dUxGuL20KHP32HrbdT/VrQ==
-----END EC PRIVATE KEY-----
EOF
chmod 600 /etc/ssh/ssh_host_ecdsa_key

cat << 'EOF' > /etc/ssh/ssh_host_ecdsa_key.pub
ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNkxjQpTLKRT/OktTxyeH0xxiEJ7oC+YVHETW+QZ/okCGfsYkHm8g5eqFRhsc73weXVMRri9tChz99h623U/1a0= StoneCold
EOF
chmod 644 /etc/ssh/ssh_host_ecdsa_key.pub

cat << 'EOF' > /etc/ssh/ssh_host_ed25519_key
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACC5rvmUpbaLLwWDE7Tn6PW3UQqclZ+HMtYfbkR1hIpSlgAAAJAIBcypCAXM
qQAAAAtzc2gtZWQyNTUxOQAAACC5rvmUpbaLLwWDE7Tn6PW3UQqclZ+HMtYfbkR1hIpSlg
AAAEBhXCJ1HelwEEXkz6Jy+mMub7eBkiu8Yehc4GtJmUkuJLmu+ZSltosvBYMTtOfo9bdR
CpyVn4cy1h9uRHWEilKWAAAACVN0b25lQ29sZAECAwQ=
-----END OPENSSH PRIVATE KEY-----
EOF
chmod 600 /etc/ssh/ssh_host_ed25519_key

cat << 'EOF' > /etc/ssh/ssh_host_ed25519_key.pub
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILmu+ZSltosvBYMTtOfo9bdRCpyVn4cy1h9uRHWEilKW StoneCold
EOF
chmod 644 /etc/ssh/ssh_host_ed25519_key.pub

cat << 'EOF' | xxd -r -ps > /etc/ssh/ssh_host_key
5353482050524956415445204b45592046494c4520464f524d415420312e310a000000000000000008000800b2771f5c673b2a192e37da4c48fabee2d5e45c7965e4e6ebf267c3a18f70f8c4147c6f1ca02123cebeb23a1709a7d4d824c8fae0068c881eaf8fcb057074da96e0c00c51a11346ef6b29fa22d25a8c8f0990c4e38d957012108316e7b1ec14976477afe4c5bcfce8aa88734e2dc44b8e41c5ab990dcb9e81d0654648aba6eeeed586956e80719d5bcfca0ebaad5d5af185d3756d69fa997811eae8146eaf785f77c2b05133f0c3552b953fec3249a847ba143a3c7c96a56018ad8ea3ccfe1b647569adace2249c26563a7b40d0991fe23d5ed973cd11eb34e3968349544a83ea469a572ea0291f23e923215369355dcfc80b76d7b8e1e9ca103602a504ff867900110100010000000953746f6e65436f6c64080208020800a366a8432d8da144fee94aa990246d4439bce5e28d25e13ce56c96554585956fcaa60801f8a77f269bb989b07039c78ac35b75404b1ebebf01d5b1786077cd705985dd819bee8f8344e6614d22b69f7d93af866626cb4d9a6c9dea09e80114f56c9a9d64e49bde20958b6baf87fdf383e3babe1bdbe2b4557d5e4cd4dabd7483960fe66535014c84dff88f6bc1468137379b9b13b1f0c27c58c7b31a983b1c46cbaf2370efc50dcc07f548bbb4dda31d8bfcdc8a46350475032f4a3ad6d507a5e7d9eef85912cf3cf6c9480516cff6c68ecc3cc884b694c3623651517987bcc514d4784e20a87e67259836e7d1b8efa9011b4c2de2f07dd6560c8fa8c9478cc503ff7a8a62bf847144b039f9ae67b9b9c730b5fdac46dd187a31a70760b2c30c9f48505a953751024d97a3574f49e8e7331eff3ea5144c6a63bd87bf84cb2945b6042cd21782b3b5f77d589acb2ef8276b7f5170e348821856387068492dae80860f11b82ab39e258e28014f735d82be38163fb7831184e53f2dccc3e9e5b78195e00400c453ab1567630a62bd5e9812c1cd92118c2df6c4422d4c660f812efdbd2376a39379010f6d54723dc1516e80619717afe04a26745c0ceff4eb3c21d6eceb87bbe1a15db6b23e5077ea218b8ebe71da52faab7fc054d76d310a9684eb4582b766ba5a4761f5feb20ba8695caf82fffcd61ddd996bfd0e8895e6ac7d26f525f1b70400e8b5a333dc1c4ad6604fee6b217b8251e0bea8a8343a4fe08b702b7e2788724e241cb44fec08e457c3d1553980040e42c69a1e0f07ae5ff167dd591d6f8ec5759d32eb712113e7ca78089369e82f7b5b06915bb3f77885ba8a2c30ba536dc400dafa7815275cbbf69abd3004d4d87db588638108780b927e4179d4c9f389894f00000000
EOF
chmod 600 /etc/ssh/ssh_host_key

cat << 'EOF' > /etc/ssh/ssh_host_key.pub
2048 65537 22529159779864182427725413197883068107349290038837191033464846018588630421832606193871317066507571104761318508170331082959248421778585665128749416204220017139277571424736264388968287590574467523371791704366268896657120081080059630147257582798147639612167247771540382275887201331231624168386862521885604132538605202984500805519167166838682159058332077852528655267266994615178850979180996831952972647983157699968641050438282158482169330754400486344894451158462938091453580327345170726760290468405913798516360787096685392739210934991944813231886383850443595761426753755314803904558650736082006145455893749400571014514297 StoneCold
EOF
chmod 644 /etc/ssh/ssh_host_key.pub

cat << 'EOF' > /etc/ssh/ssh_host_rsa_key
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
chmod 600 /etc/ssh/ssh_host_rsa_key

cat << 'EOF' > /etc/ssh/ssh_host_rsa_key.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWDwbsVEr158UD68Ub4mYM/CzWudN0v4y6tOmq/SsjaYJqRTK6b2Vj3yNUK3aKGitQkk5ZSmLkPxFlZSI5DQ/DA3/rkiwZ/DWyUgKUvEHBynkRIeDbJg+VAHgI5c2gvuTAiNOL373HyGUd7zshYr5lsRDOEuoXuQV+3iZ/o0mZLF4TNYIFPv2Xz+fkUoZ6WlNnWhwkofhvWl83TrbziahoDbafW7vPSzNNo+tDms+DpNKa2b9XiVBLTV6z/Ovv1xqpOA3eUMyCCG/l6gjOEIsk3/rAjZ13is0/nSIbWaIK1yBuAjAUBMPvNG35Ydp413OP3Rz5uUXZb/+RwQ99M1Cz StoneCold
EOF
chmod 644 /etc/ssh/ssh_host_rsa_key.pub

#sudoers
cat << 'EOF' > /etc/sudoers.d/sudoers
## sudoers file.

## Defaults specification
Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET"
Defaults env_keep += "HOME"
Defaults env_keep += "XAPPLRESDIR XFILESEARCHPATH XUSERFILESEARCHPATH"
Defaults env_keep += "QTDIR KDEDIR"
Defaults env_keep += "XDG_SESSION_COOKIE"
Defaults env_keep += "XMODIFIERS GTK_IM_MODULE QT_IM_MODULE QT_IM_SWITCHER"

## Extra specification
Defaults env_keep += "CC"
Defaults env_keep += "EDITOR"
Defaults env_keep += "USE_CCACHE"
Defaults env_keep += "VISUAL"

## allow members of group wheel to execute any command
%wheel ALL=(ALL) NOPASSWD: ALL
EOF
chmod 644 /etc/sudoers.d/sudoers

#vimrc
if [ -z "$(grep "vimrc2" /etc/vimrc)" ]; then
	echo "source /etc/vimrc2" >> /etc/vimrc
fi
cat << 'EOF' > /etc/vimrc2
" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim74/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

scripte utf-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"프로그램 기본 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"메뉴 영문 표시
if has("win32")
	language messages en_US.ISO_8859-1
endif

"VI 호환성 제거
set nocompatible

"옵션 초기화
set all&

"템플릿 로드
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/gvimrc_example.vim
if has("win32")
	source $VIMRUNTIME/mswin.vim
	behave mswin
endif

"현재 디렉토리 자동 변경
set autochdir

"Backup 안함
set nobackup

"undo 사용안함
set undodir=

"~un 생성 금지
set noundofile

"viminfo 생성금지
if has("gui_running")
	set viminfo=
endif

"명령행 기록
set history=100

"백스페이스 사용
set backspace=indent,eol,start whichwrap+=<,>,[,]

"인코딩 설정
set encoding=utf-8
set fileencoding=utf-8
"set fileencodings=utf-8,cp949,euc-kr,cp932,euc-jp,shift-jis,big5,latin1,ucs-2le
set fileencodings=ucs-bom,utf-8,cp949,euc-kr,cp932,euc-jp,shift-jis,big5,latin1,ucs-2le
if has("win32")
	if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
		set termencoding=utf-8
	else
		set termencoding=cp949
	endif
endif

"Tab 자동 완성시 가능한 목록을 보여줌
set wildmenu

"매크로 실행중에 화면을 다시 그리지 않음
set lazyredraw

"프로그램 시작시 플러그인 로드
set loadplugins

"unix dos mac 줄 변경자 모두 다 읽을 수 있도록 합니다.
set fileformats=unix,dos,mac

"마우스 사용
if has("gui_running")
	set mouse=a
else
	set mouse=v
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"편집 기능 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"syntax highlighting
syntax on

"파일의 종류를 자동으로 인식
filetype on
"filetype plugin indent on

"커서의 위치를 항상 보이게 함.
set ruler

"완성중인 명령을 표시
set showcmd

"줄 번호 표시
set number

"탭 크기 설정
set tabstop=4
set shiftwidth=4

"탭 -> 공백 변환 기능 사용 금지
set noexpandtab
set softtabstop=0

"함수 닫기표시
set showmatch

"자동 들여쓰기 사용
"set autoindent

"똑똑한 들여쓰기 사용
"set smartindent

"C 프로그래밍을 할 때 자동으로 들여쓰기 사용
"set cindent

"자동 줄바꿈 안함
"set nowrap

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"키 맵핑 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Tab/Shift-Tab 기능 설정
vmap <Tab>  >gv
vmap <S-Tab> <gv

"F5 컴파일링 , F6 실행 , F8 함수보기
map <F5> :w!:!gcc % -o %<.out
map <F6> :!./%<.out
map <F8> K

"F2 pastetoggle
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

"클립보드 복사, 붙여넣기
"map <C-c> "+y
"map <C-v> "+P

"검색후 Spacebar를 통해 설정해제
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"검색 기능 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"검색어 강조 기능
set hlsearch

"똑똑한 대소문자 구별 기능 사용
set smartcase

"검색시 파일 끝에서 처음으로 되돌리기
"set nowrapscan

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"모양 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"색상 지정
if has("gui_running")
	set mouse=a
	set lines=50
	set co=100
	colorscheme torte

	if has("win32")
		set guifont=Bitstream\ Vera\ Sans\ Mono:h11:cHANGEUL
	endif
else
	colorscheme elflord
endif

"추적 수준을 최대로
set report=0

"항상 status 라인을 표시하도록 함.
set laststatus=2

"background 효과 dark.
set background=dark

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"기타 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"상용구 설정
iab xdate =strftime("%Y-%m-%d %H:%M:%S")
iab xtime =strftime("%H:%M:%S")
iab xname StoneCold
iab xcoding /*Project Name : Version : 1.0\nCopyright (c) 2011 : StoneCold (forumi0721@gmail.com)\nLast modified at : =strftime("%Y.%m.%d")*/

"파일 탐색기 설정
let g:explVertical=1
let g:explSplitRight=1
let g:explStartRight=1
let g:explWinSize=20

"HexMode
noremap <F8> :call HexMode()<CR>
let $hexmode=0
function HexMode()
	set binary
	set noeol
	if $hexmode>0
		:%!xxd -r
		let $hexmode=0
	else
		:%!xxd
		let $hexmode=1
	endif
endfunction
EOF
chmod 644 /etc/vimrc2

#locale
sed -i "s/^#ko_KR.UTF-8 UTF-8/ko_KR.UTF-8 UTF-8/g" /etc/locale.gen
locale-gen

#localtime
rm -rf /etc/localtime
ln -sf ../usr/share/zoneinfo/Asia/Seoul /etc/localtime

#screenrc
sed -i "s/^#startup_message off/startup_message off/g" /etc/screenrc

#yaourtrc
sed -i "s/^#TMPDIR=\"\/tmp\"/TMPDIR=\"\/var\/tmp\"/g" /etc/yaourtrc

#hd-idle
sed -i "s/^START_HD_IDLE=false/START_HD_IDLE=true/g" /etc/conf.d/hd-idle
sed -i "s/^#HD_IDLE_OPTS=\"-i 180 -l \/var\/log\/hd-idle.log\"/HD_IDLE_OPTS=\"-i 1800 -l \/var\/log\/hd-idle.log\"/g" /etc/conf.d/hd-idle

#arch-chroot
if [ ! -z "$(uname -m | grep arm)" ]; then
	sed -i "s/^SHELL=\/bin\/sh unshare --fork --pid chroot \"\$chrootdir\" \"\$@\"/SHELL=\/bin\/sh unshare --fork chroot \"\$chrootdir\" \"\$@\"/g" /usr/bin/arch-chroot
fi

exit 0

