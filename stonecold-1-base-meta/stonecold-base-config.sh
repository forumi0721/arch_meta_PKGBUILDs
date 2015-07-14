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
else
	LANG=ko_KR.UTF-8
fi
EOF
chmod 644 /etc/locale.conf

#ssh_host
cat << 'EOF' > /etc/ssh/ssh_host_dsa_key
-----BEGIN DSA PRIVATE KEY-----
MIIBugIBAAKBgQCARHnAY9LGH5pnkSdpEgSsAvjFeaPG0jyaeD3QFm9mxCe07Vj7
4TTNQ20ksweZxXsINTUZmcBpn6fDvR6qtGik8zsuouZpHTjBrTh53LJ3pdZ2Vydd
+nKbFu4nA3S14tY9x35VBOlUpyD3xkA3YpYQ7EV4NlNWaJvoWWpoNqPXUwIVAIgq
r0mKrGI3O9Or/ayRAk7z5mV/AoGAOJWa1wmzMqWa3HQk8ERG+ojfZIBt2QKhjO84
lir1OXk8CWhaYP2FpicKe7S78nzt6wjHTD66dkwdW7YkUr+yn054FsY2++pUs2ib
uUR6bGuh+WT8xyCQRtUkZLZPGwE9AzVNGFiH4K1jU0wPzSOiofQVMto2Ad55RVn2
j6I6JNgCgYAW5S9UsZjmL8rNmo0zJW+zQG3e0LjzCBzQDWXJ7lRKLEJCcmNkMGgI
7vAdxi7yMSr/QjkED3sdN7p/m4Gs+metHz+QCLzob3Ieg/1ypmGMbjK6C2k/Q4yf
eMixOYKvjmj2FrII1ldWBtQl6/qqRSYPKBIkoN5xdxl/cuFtGJPmWgIULV7JwPI6
e4srwaKa95wZ1zLPIcI=
-----END DSA PRIVATE KEY-----
EOF
chmod 600 /etc/ssh/ssh_host_dsa_key

cat << 'EOF' > /etc/ssh/ssh_host_dsa_key.pub
ssh-dss AAAAB3NzaC1kc3MAAACBAIBEecBj0sYfmmeRJ2kSBKwC+MV5o8bSPJp4PdAWb2bEJ7TtWPvhNM1DbSSzB5nFewg1NRmZwGmfp8O9Hqq0aKTzOy6i5mkdOMGtOHncsnel1nZXJ136cpsW7icDdLXi1j3HflUE6VSnIPfGQDdilhDsRXg2U1Zom+hZamg2o9dTAAAAFQCIKq9JiqxiNzvTq/2skQJO8+ZlfwAAAIA4lZrXCbMypZrcdCTwREb6iN9kgG3ZAqGM7ziWKvU5eTwJaFpg/YWmJwp7tLvyfO3rCMdMPrp2TB1btiRSv7KfTngWxjb76lSzaJu5RHpsa6H5ZPzHIJBG1SRktk8bAT0DNU0YWIfgrWNTTA/NI6Kh9BUy2jYB3nlFWfaPojok2AAAAIAW5S9UsZjmL8rNmo0zJW+zQG3e0LjzCBzQDWXJ7lRKLEJCcmNkMGgI7vAdxi7yMSr/QjkED3sdN7p/m4Gs+metHz+QCLzob3Ieg/1ypmGMbjK6C2k/Q4yfeMixOYKvjmj2FrII1ldWBtQl6/qqRSYPKBIkoN5xdxl/cuFtGJPmWg== root@alarmpi
EOF
chmod 644 /etc/ssh/ssh_host_dsa_key.pub

cat << 'EOF' > /etc/ssh/ssh_host_ecdsa_key
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIDD5JL87mgZUt5ECGkz2Do9L0iRPGB+4LRFdc2jHVOyLoAoGCCqGSM49
AwEHoUQDQgAE+BnZgA0yqmRzB6b4wLw4gQsPIFtItifCoCVgEs2Ehcpj1FbSdVo6
XSgbRKntdjEmUPGy9jgz2X45MVTchbCUyg==
-----END EC PRIVATE KEY-----
EOF
chmod 600 /etc/ssh/ssh_host_ecdsa_key

cat << 'EOF' > /etc/ssh/ssh_host_ecdsa_key.pub
ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPgZ2YANMqpkcwem+MC8OIELDyBbSLYnwqAlYBLNhIXKY9RW0nVaOl0oG0Sp7XYxJlDxsvY4M9l+OTFU3IWwlMo= root@alarmpi
EOF
chmod 644 /etc/ssh/ssh_host_ecdsa_key.pub

cat << 'EOF' > /etc/ssh/ssh_host_ed25519_key
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACAKnS+cbg7QckFaBmH7sSU4FfUh7C0xC00GOE4EicfQ6AAAAJDFqmrmxapq
5gAAAAtzc2gtZWQyNTUxOQAAACAKnS+cbg7QckFaBmH7sSU4FfUh7C0xC00GOE4EicfQ6A
AAAECoKdf6sQKG5ZkWGJI7lHPNP5BY00stcWgjVo70Pnj/BgqdL5xuDtByQVoGYfuxJTgV
9SHsLTELTQY4TgSJx9DoAAAADHJvb3RAYWxhcm1waQE=
-----END OPENSSH PRIVATE KEY-----
EOF
chmod 600 /etc/ssh/ssh_host_ed25519_key

cat << 'EOF' > /etc/ssh/ssh_host_ed25519_key.pub
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqdL5xuDtByQVoGYfuxJTgV9SHsLTELTQY4TgSJx9Do root@alarmpi
EOF
chmod 644 /etc/ssh/ssh_host_ed25519_key.pub

cat << 'EOF' | xxd -r -ps > /etc/ssh/ssh_host_key
5353482050524956415445204b45592046494c4520464f524d415420312e310a000000000000000008000800e45ce831ce81142a141a423431daa21148a5e308113a0cd132c72cdcadedd2c0c0088990241d5dbb3ece9f059b1d1c9ba222734ec5b4cc97feb9ea056d57190c6038dfeabac3e7842266329629f4a84fa7fd5d7f7d881d98af365e736bad8e8f4bfaa5c8dbb3fc52bc7eab132254d3d62d4c1ec21002d60a2d32019c20a45954e6c1d43a495048600c5d3bd70dba0f3a5df0dec7853d1dc634f487ccc9eed5cb81b27f61768fc088ed68d6b485172b22ffd2e4e0c977e2f2403af79ca7f279f322e09b84fd685379ade51f7aeab7a85e0d493b589e67ce6ff98d4a89ab2124acc50abb9765e39a14ed18e58a5f140fb9bd7968b847e410af6063028ff3c3563700110100010000000c726f6f7440616c61726d7069b886b88608009c393ad7a7f001fd6f572f67499bca378cbd7f7d2b5bcd1ce861fdbcd277da2fe6af707c5d5881a0f12ca4f94ece319dfee316831319c6c54c8b9f1f2b57e458e512c38c6f4c49fbc914a512b98d17ffb66acc25c598f2b65b5714725d7d94034ff51ea9343403300ea7911d3be5502e3b3ad1e7ecd023e13e5df15fffacaf36ecf984d579a162b59b2a66768d9b09a3f1fa17ed4a4b8f11c38d38f853a3aa0d2435e8d9e703a3cda4b7f8102fc93db1514a0e9e54ff5e649456a8baa5e763a2bad12afbdc458e0e5b25d806cd6c990cf791e687318b7a9463820c030cc9a5da03607efd045531a16474d6f609d96bf7e3eab8d3527b3a796e3a32ca5f3b44b103ff591a7ad791abfba0b924bc55f9eabb21d713edeb3b9520b2d875b064f5dfc890fd212e187511197eb789161151f568a8d3ab458f411e984d9cead06f342d11c44a4b4373927606e2d17b679b14da2e657ed593e55cdbd9405598c9b9617564304eb64448cbdf108bded381473db3bb2e7084909d49be596b2c10be1ef80305240400efbd52c1a3177259546e7cc5e5a3844a8d090955e9ad0649262eb71f1d23d42f5fab2a280d4583b064e623d35d68fe2074e66d4add90f76b8ab5c4468083b54a00cf5c4f0f06f4b6d800946d594ba7ef5d5600c5d8d091f1ca61ae3125dc8ccccbcce2d41cde94761229897862cbe5334a62367212aa937c6ff1b0b4d754c58d0400f3da0c31d2061b5cbbe2443aa50c077fde701e9492fb4e319767ff665aac29b3591cbd39f5d08508ff10129c973bb7936be06595ec769bd6a1ff22dc900cdb486765f0251177340165f7122b6c3dfa0d16d994424e88cfefa10c125a5202ecd746aa66fa49910aa74280339dae37f0812c9a7c9e1975aa9fa42bd5d231264fd300000000
EOF
chmod 600 /etc/ssh/ssh_host_key

cat << 'EOF' > /etc/ssh/ssh_host_key.pub
2048 65537 28828147686403985696810889128809346956039689304993481521112362465713198616808859981906572184393426807040704583153810365766770912275094056566027418820439646985892831180380975351378227449288817923928603621907320545518881499435749643413114861059873465567501477056066903544367735741061504067234855567052960516004477096315294429751942763477598129099806960590529373304671306550600315032427877878364297885421153869151982162784740230580367290793685019996604561302815616792687123097294408248385684908713263683440517831150401624062692556653903923416541854775359907882255753597987920814429191327086290012110163872945286167090743 root@alarmpi
EOF
chmod 644 /etc/ssh/ssh_host_key.pub

cat << 'EOF' > /etc/ssh/ssh_host_rsa_key
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAyIRmFVSjd319MRy7cLj20pzjK0+O3370m81HrQ9r93VhEkMA
mY91WGWG6bAzJFL5cKPv4jFZb5haAm7e7uDmW095DaB7rEhcC0yI+5N4385tariP
Yn3nHNugjxLppcrVbT44oDSs+dT27TH6Vf0QFyUMvbZusvOe1RQGua6vz3Y68zSf
ov2F2iBPvY7SMDmQ86viALScaJPWYd3tf7EDNq7xeEclx2SGBfNSfO3Io3xf7lg5
L3aRPzMtafIWklK6EAbLoozHLrbfvdga0zG2WoW/b5M2fznUTRsANHeiKx77G/0s
sKX33BMAPgjts8Xy7KE52IaAL8wSAKJom2jJHwIDAQABAoIBAEbsteMDnhJs27Rc
clxrwDo87glqyaF6GXFmidzH4KuV5DD+bB7k5F/RAYh1H5HQm5RhGD+MrxLO8796
kfYyrKhNkwbj5frJWW1Rs/4waofXT1J5V5ZB7FaDxOX2jZhsB1Pttz/LggeYcYLy
s5ZovaFCJKCR/9PiYiMCQ2K4TE135tGR4nAEPI+8fD82ICbN2IEEorBwxTmfvNeT
+nlcGg746VWfi0SHGj6G3Pjp6yQ07UOg9uEXQLF5UOq2YscnJlTbIww64Eci39MH
RWWHQXJEVmn0ddSJQltvSLlT46qTMtAICTYg/8/WYo4bnkViv3J9cKCkcfXbNBN/
GUQWiTECgYEA8EmKJGJQ9PAjIjJO6fkxhBSOuIHwRGCyBbxIYstsGTJHmt+YwHkT
UU0tP4bA7FMaDhMXd7ARsBNWfdQaCRZr7DFX2KffBKpxG4vgPeB08+z1RJqhSEbh
lJUmeKeMZ6dFWSbTEYsuigggaX+mVVG+PhEgPiafvdIFIUFDz4Mhl6kCgYEA1aEZ
dTDaMQjPmfj/ABHb5RVNjtzlnFSlZAe9sgxsXjdkV5LJC4KdghjI829QGZIxEkt5
iTrx3+pXOHVfZY+rmC/s6lmkk7miFzi0JoiOw3MC30fPZloD9HAv8SGAs+lRzdTA
3p1uFjuC+ocOHn7Xq0ILUvtoBF7CF9KmS5QIt4cCgYA2Xa0vxj7i7GJGnnNUZNlb
NPuFq4CdN/OPcKZAFB6FJOcml2iMQ9inEHsoYGjOD49Zl+A7aE7YM8fh+FdbrwME
EbX6gyDmgVnODbvSxDIx7m8f8oyDOeZYI9bsfZw655G9NheTZJZHDMeolwUfULtm
d6F/7mU+IYKfn5CkJts24QKBgQCrkdi6T+PMocDpbhqOWcl68GL7q9kUdr7l2Xm2
N1gJSv9hfdfNULdjNridGfcAsnKKuOcBGcAMD07BXzKghIRRk5v4ksokgl/1umqk
z+OogQP7gtbE4uJuPHOkez28QFSctJO5tkIlxOHqhvEF+OUI+9/QY20kpV3IeDtq
U5e0nQKBgA45KtjjuwVvYMkDVFo8vccJ4GeimR5tWM5wPMTeJ8cL9t8t//y26u/o
eog+YMRnFjePHftEUSDkQUdUJnkYSQl1a3cwmdzidBuQTUryWqMkQO/RXj20BGbf
61YOhzEhbmjZxvG1Sl2MuYdxvlibt2mkr4EIvQ4YzhNDLMxeECRf
-----END RSA PRIVATE KEY-----
EOF
chmod 600 /etc/ssh/ssh_host_rsa_key

cat << 'EOF' > /etc/ssh/ssh_host_rsa_key.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIhGYVVKN3fX0xHLtwuPbSnOMrT47ffvSbzUetD2v3dWESQwCZj3VYZYbpsDMkUvlwo+/iMVlvmFoCbt7u4OZbT3kNoHusSFwLTIj7k3jfzm1quI9ifecc26CPEumlytVtPjigNKz51PbtMfpV/RAXJQy9tm6y857VFAa5rq/PdjrzNJ+i/YXaIE+9jtIwOZDzq+IAtJxok9Zh3e1/sQM2rvF4RyXHZIYF81J87cijfF/uWDkvdpE/My1p8haSUroQBsuijMcutt+92BrTMbZahb9vkzZ/OdRNGwA0d6IrHvsb/SywpffcEwA+CO2zxfLsoTnYhoAvzBIAomibaMkf root@alarmpi
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

"viminfo 생성금지
set viminfo=

"명령행 기록
set history=100

"백스페이스 사용
set backspace=indent,eol,start whichwrap+=<,>,[,]

"인코딩 설정
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp949,euc-kr,cp932,euc-jp,shift-jis,big5,latin1,ucs-2le
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

