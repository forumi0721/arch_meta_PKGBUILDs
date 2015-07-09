#!/bin/sh

sed -i "s/^#display-setup-script=/display-setup-script=\/etc\/lightdm\/display-setup-script.sh/g" /etc/lightdm/lightdm.conf 
sed -i "s/^#xserver-command=X/xserver-command=X -s 0 dpms/g" /etc/lightdm/lightdm.conf

if [ -z "$(grep '<property name="shutdown" type="empty">' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml)" ]; then
	sed -i 's#^</channel>$#  <property name="shutdown" type="empty">\
    <property name="ShowSuspend" type="bool" value="false"/>\
    <property name="ShowHibernate" type="bool" value="false"/>\
  </property>\
</channel>#g' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
fi

exit 0

