#!/bin/sh

sed -i "s/^#disallow-other-stacks=no/disallow-other-stacks=yes/g" /etc/avahi/avahi-daemon.conf
if [ -z "$(grep -w 'include /etc/nginx/conf.d/*..conf;' /etc/nginx/nginx.conf)" ]; then
	echo 'include /etc/nginx/conf.d/*.conf;' >> /etc/nginx/nginx.conf
fi
if [ -z "$(grep -w 'include /etc/nginx/sites-enabled/\*;' /etc/nginx/nginx.conf)" ]; then
	echo 'include /etc/nginx/sites-enabled/*;' >> /etc/nginx/nginx.conf
fi
