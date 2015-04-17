#!/bin/sh

sed -i "s/^#disallow-other-stacks=no/disallow-other-stacks=yes/g" /etc/avahi/avahi-daemon.conf
sed -i "s/^NoNewPrivileges=on/#NoNewPrivileges=on/g" /usr/lib/systemd/system/minidlna.service
