#!/bin/sh

if [ "${EUID}" != "0" ]; then
	sudo "${0}" $@
	exit $?
fi

sed -i "s/^DISTCC_ARGS=\"--allow 127.0.0.1\"/DISTCC_ARGS=\"--user nobody --allow 192.168.0.0\/24\"/g" /etc/conf.d/distccd
