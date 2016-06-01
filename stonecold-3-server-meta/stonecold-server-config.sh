#!/bin/sh

sed -i "s/^#disallow-other-stacks=no/disallow-other-stacks=yes/g" /etc/avahi/avahi-daemon.conf
if [ -z "$(grep -w "include /etc/nginx/conf\.d/\*\.conf;"  /etc/nginx/nginx.conf)" ]; then
	lnum=0
	lastl=0
	while read -r line
	do
		lnum=$((lnum + 1))
		if [ "${line}"=="}" ]; then
			lastl=${lnum}
		fi
	done < /etc/nginx/nginx.conf
	if [ "${lastl}" -gt 0 ]; then
		sed -n 1,$((lastl - 1))p /etc/nginx/nginx.conf> /tmp/nginx.conf
		echo '    include /etc/nginx/conf.d/*.conf;'>> /tmp/nginx.conf
		echo '}'>> /tmp/nginx.conf
		cat /tmp/nginx.conf> /etc/nginx/nginx.conf
		rm -rf /tmp/nginx.conf
	fi
fi
