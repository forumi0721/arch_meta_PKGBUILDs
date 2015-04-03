#!/bin/sh

sed -i "s/^#disallow-other-stacks=no/disallow-other-stacks=yes/g" /etc/avahi/avahi-daemon.conf
