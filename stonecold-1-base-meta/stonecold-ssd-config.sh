#!/bin/sh

echo "# Decrease swap usage" > /etc/sysctl.d/vm.swappiness.conf
echo "vm.swappiness=1" >> /etc/sysctl.d/vm.swappiness.conf
