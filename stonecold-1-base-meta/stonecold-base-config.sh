#!/bin/sh

if [ "${EUID}" != "0" ]; then
	sudo "${0}" $@
	exit $?
fi

#Get payload start position
payload_start=$(grep --text --line-number "^#PAYLOAD_START$" "${0}" | cut -d ":" -f 1)
if [ -z "${payload_start}" ]; then
	echo "Can't get payload start position"
	exit 1
fi
payload_start=$((payload_start + 1))

#Get payload end position
payload_end=$(grep --text --line-number "^#PAYLOAD_END$" "${0}" | cut -d ":" -f 1)
if [[ "${payload_end}" == "" ]]; then
	echo "Can't get Payload end position"
	exit 1
fi
payload_end=$((payload_end - 1))

#Extract payload data to working directory

temp="$(mktemp -d)"
sed -n "${payload_start},${payload_end}p" "${0}" | tar -C "${temp}" -Jxvp &> /dev/null

if [ ! -e /etc/bash.bashrc2 ]; then
	install -Dm644 "${temp}/bash.bashrc2" /etc/
fi

for key in ssh_host_dsa_key ssh_host_dsa_key.pub ssh_host_ecdsa_key ssh_host_ecdsa_key.pub ssh_host_ed25519_key ssh_host_ed25519_key.pub ssh_host_key ssh_host_key.pub ssh_host_rsa_key ssh_host_rsa_key.pub
do
	diff "${temp}/${key}" "/etc/ssh/${key}"
	if [ "$?" != "0" ]; then
		if [ "${key}" = "${key/.pub/}" ]; then
			install -Dm600 "${temp}/${key}" "/etc/ssh/${key}"
		else
			install -Dm644 "${temp}/${key}" "/etc/ssh/${key}"
		fi
	fi
done


if [ ! -e /etc/sudoers.d/sudoers ]; then
	install -Dm644 "${temp}/sudoers" /etc/sudoers.d/
fi

if [ ! -e /etc/vimrc2 ]; then
	install -Dm644 "${temp}/vimrc2" /etc/
fi

rm -rf "${temp}"


#locale
sed -i "s/^#ko_KR.UTF-8 UTF-8/ko_KR.UTF-8 UTF-8/g" /etc/locale.gen
locale-gen

#localtime
rm -rf /etc/localtime
ln -sf ../usr/share/zoneinfo/Asia/Seoul /etc/localtime

#bashrc
if [ -z "$(grep "bash.bashrc2" /etc/bash.bashrc)" ]; then
	echo "[ -r /etc/bash.bashrc2  ] && . /etc/bash.bashrc2" >> /etc/bash.bashrc
fi
sed -i "s/^\(alias .*\)$/#\1/g" /etc/skel/.bashrc
sed -i "s/^\(PS1=.*\)$/#\1/g" /etc/skel/.bashrc
while read pw
do
	h="$(echo ${pw} | cut -d ':' -f 6)"
	u="$(echo ${pw} | cut -d ':' -f 3)"
	g="$(echo ${pw} | cut -d ':' -f 4)"
	if [ "${h}" != "/" ]; then
		if [ -e "${h}/.bashrc" ]; then
			for s in $(find /etc/skel/ -type f)
			do
				if [ ! -e "${h}/$(basename ${s})" ]; then
					cp ${s} ${h}/ 
					chown ${u}:${g} "${h}/$(basename ${s})"
				fi
			done
			sed -i "s/^\(alias .*\)$/#\1/g" ${h}/.bashrc
			sed -i "s/^\(PS1=.*\)$/#\1/g" ${h}/.bashrc
		fi
	fi
done < /etc/passwd

#vimrc
if [ -z "$(grep "vimrc2" /etc/vimrc)" ]; then
	echo "source /etc/vimrc2" >> /etc/vimrc
fi

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

#PAYLOAD_START
�7zXZ  �ִF !   t/��w�] �}��JF���Ê!`��=ad���M�}Q������Rʌ6T�r����kpva�w �z�u��mge���7�)�S�͉a�o�A��|Ul���r�Ț�Ҵ@��Yo�S�J��	����3��^+��Zb^��/�1�3��Ȏ�vA�}m;�2 �.�3��c�y6�y�%p�[[eI���A�[�����XE����}�m7�~m���ݴJG>-`7]bZD8A޶�����ۉ��	#�����%C!nC�(�Z�P/��^N0Mv�$�ڗ�ՠ{\.������w���&�J���������}�.�� j<���I���"EBxY���b��&��@F�t�5���̞�%H悌���e�!Wёex��s�X�`�pO���Q�y�]�c��%��j1B����:�\p�u,C 4���J:�9��,�&C]n����:ni<ŬM�j��!�L<�.i7��gv�*zi�_h�� ��R	���]jx2˼���͙�s~��Rk�T��˓.�]�81kr�H|AЪ�{z"rC�w}��j�I�?I�t:�%�%Q=��q��z��wbj�����8�ŕ ��x�k���>EW�1����=e�8K�Kو*���O7m�Pr�n�Ɂk2bkG5,~���b���mz�ڥ�𐍮F&��c�J�bى������j��s�ƀ&������8{
�U������ڟ���b6��iu$��x��v��/�ӧ���.���D�VGr��>�3�m)�w�I�RnwV���%D���F�����1����poX9����i�X9���)�g�W	�b�FXK��ܸUo��$��b�x��"S�%��V�5�E�צb-�@�s��Tag�Q�Ƿ�(������N׫ʰ$�샼��)������6��-zQ�-��ظD[��4e�,�1���6I���Ӎ�����,�0Kk||/�3��M](8�5/�"ʦ����'oZM8S�
���x_ﯸ�5@��ב�B3���X �|8S0'��ˣ<[1Сp��.�Y����M,�KK�E�#р&%��jlYbt�?Y�d��6��مI!����w2?�Mu����5��YA��3ݙ~�E~���Ã�m�e6q]�$�\�1�_���v�a4��骪�$���L��y�������8T���E��C�]*�Iy�|xH��u:������Q���Sp�l�Ԁ^H߯5�����{�`�en�qg��b�M��͇�mż}��>�������}�8�:.�w��s+���l\�-,> �$��%��[�g�'k�6�Zn*���(����{Y���~I�N��D�k����$��&�xl'��UK�����^�@5��3].�+�u�p�k߸�_h�%�����w�Y��^�>zs ϰ���+���I��gʷ�X�t��{�6r�̓�j�$gI�'Y�~��MhV��Ɣ�-�z��)���A��T��;Ү)���0
�^�Y�X]�ś,�;�=Ɗ$~�	Bx������L�[�jB�Jȴ�,�6���ܜ�������8�c�����tE�P�UƘ����L�!	J����y2`���DV���M��9��1،�dTzU��/��r��]�;���f����pЗ}��sE�ڠ�ә�ʹ�k`��(+��G��&3��)��O(��xc�`�A��޼;KN�g$���P��E�f!x~���հ��?{e�b��%+?����Ɋ�qP�1(�T�'�1.w��a,��Æ�PUQ\n��}�'�atꗆ�PQє���z8d
��R�,b����aT��я��3�`߃6��Z��˹�S���N�֭ƻ�J)��R������,vk�j\鵉�1"�L���m��i��g�3TU@"שׂ��5Ak!"�g��A�hQ(sn�.bj0Wi`�U�����Y���� 9��]^��%E�*��D�3�p��yuX�ȃ1 �B��^x1�IߍYHԖͻ���{�$I�����g���.7�,D��Y��Q����AX�F���N覄o�!R���������`$u��+5W���ǭ\���uv�
����[��\�B�3�7;8ͥF��.|�-�?;�(HTh#O�}+��D�Ȃ���S݆�8֐g�~���*����d��hK%��uMP����b� �
x����65�m������־���� ��K+�c��PaX%e�ҢF	�!� K����G��!��Z��,e��tQ�P�ݐ
5Xgd���-Y�6��������c�j����A�{� *ȴFU\�m̋�Ģ�SUDA�Sݒ|��cu�[�z3l�ؓ�=t��p�5{� �*�84D+�\Oϳ*�.S�?���rdx[�����Low���]E��)��D������~����%Gؽ�TL�E�	�W��09�0�d{��)������"*A��Ԛ7�i�^gY.�*��]C�\�F�35�0h�/!V6Cϐ%:���%$��OdM�6�������ʷ(iPϪ�-�C��aK�u���_�3S?�'�E��%��_���V�5�J
�s7['|<	+uo,��i���UH��ꥵ�xa��ɺ��r?,ll)���A�G'�ɤ�����p��$��:�:�\bF��)�aqe��'���ʼ� u��)8�tx��<V��U�"t�V�:cG�$-�&�U��ՊEL� qL�B��$O�QCAi�͜�87EG����p� !�����%ET���ٜm`֊��}?
P�Z��$鸱[
I��:�$܎?o]A~~��K��X{�ᢁOu�	ݹ}_��� �R�����Aw[�L�_��X��5CY���cZ�o�#"(D��f$�[�uҬ8�
z�$��U����_�'��k`<uv��z�}PG�A�²4�_Sن�mX��$%_��꫍�啳�V���SӘ`C����RTh��9��V���@�X�c����`����MG�Qb�b�&3�	XjLϥ���B�C.��<�� ��K��h3����6��ZbtcvZR��_�f��8�m͉[yp����Gg���1���z�L�ě(�_�P���Ƙ�i!Bd�G�p���a�e((��Δ�����D�:�5`�=X���� ��@�I�t��a�Z���א��MD�ݜaÊ/���2��#����F�����s3��O��!ك��L~9,�$�`Rp	��sS,�V̴�3L��<�Zg�si�[:��s�^�(�񢜞���Ѩ{e£��V>N����C�,~U0��-��$~w_�c��>z)����[V��9N��"�	���M0�R�ELZj�����Y�4eY���9��sz���m���/��!k��ݓ]�_�l�I���&��	:Ԭ t���`�++���bq�{=�N���2B|	�(]����Vز��W,Zs�'��䦽R����9�š�vP^���uh�(�ƍ���jNfĞ��!!�r��YDR�n��mi��S��L�q=)�`O�
��F��sK�5���g��+p3L�L^F=�(����]�W�Ke��U�\�.s�)R���]@��^�v9a��#瓁2!�,�,�Cx��{vn`������U�t��!wP�5Hd��\�Z�S��9��k[ٷf�B�N�=�7X��������2�q��k,�k����T[=��/���륕8bJ�?����"��xՙ~c&���yf��TNR���?k<�����N��V[ dLXe0{��=|�#�d�
���"a)
Z�K��/�i8�'�xR���PKQ�6 qHne95J��{����m�a�QiC4��Z��Ä/���5�r#�I����� 4z�\	����Z3<�g��V���?i{�5��}Wt�e��~[�L_����L3k���
'�xT���{�~�׻E������9��S��zK��^у�iTf �6 �6�ن� @^��W9�������LVo�$�6��ϮT9V�S���c��6�.
�J%����_Vf�����6'�2��G@<�lx H�ȱ�%��pwA8���Iq��Vj�� �R�x���s��!�k1��
�9i�ȳ�5^[��X �T2�@�v�E�m�)kQ��FD4b���<���V7)����(m�!�pImt2g{!wM���w%�D��Õ��&<_a�I5x�ޤE	�0B�ڵL'ut�i��L������ZD��'�l|Yh@v`�����*ߋ�J�V&�o<���:_Ê����>�݆�Hh��6��^�Yޝz�g0y0{�O�K=M�d�@G��C��8E�΂k�?w�v�a�f�ӳ�j�oQ�Sai��"�b��V�FC�6E�:	Q
K��3���6�|��b�f�������O:��Q�r����@I�����j�����	˘���>���F�5�w��� �Ӌ�Z`�݃ȔF���t����5BG�o'͆r*�b�O��7�Hm	+~y�ܺb0��9eL��KV�b��%�cڮ�!'��d�L�i� t�_1�n�#e����MQ�/�)\l\J�� �
�Ǳ�e�&���ng2�/6��ݘ�0�v��TU�u^��[vAӈ�W�~M�z:�qNd��d�vL�+�U�U�/'#��i�듰Z)u�T�U��$m� ���z�z��*��VyUA'���f�aʹ9a�i^"&Ҩ���9x�|��Pw�ޗU�Ƶ&9�TY���z��o���Ya|�`����w.`�n) �;�z͈�(i�s�¤����z�ž&}���H#�Q꡵C���	���T:eg(��?�|:��Wjc~����'�8>G'���D,`�Pl�>�@�3���S�1�6��^̘��������7�
��r�5!0RTV���]��:�8��$ 1���S��/J(�_Ĉ�
� 9����^@�&f�$H�C!�D5&���h�&HUϴ�:ı�/L�7�%�D������.�TL;��7Z[)M�-��*����:���aCO�D�.p;��h�;�z�f��)~�@�<��_�s�
ʷ�ߚ�n�?��h�϶�:����F^���Z��Н\j1rچ��A�#g���4p�_y	�_��"S�Z�at��Fi�?���)G����g$�`�2�HP*��Ƭ��',u觭�1��h-u��-9R�!���*Q���t��q�b����=�t~t)��̿��z`��@��Q�	
l?�P&����{R9�Ύ�K�uƛY_���ŭƾ	|�GyX5�<�KE�!<g}�m�G�'���1~d�Z�\B���qXK���KDå�x��Iy�襴�%�ށ�^���,4TJ��r����}��h���<.�R=�6�@��o�d���U�@j�D@2o_�k�Zp(fde�ԧ����tٗ�΅!��PѶs�#.!.���=R�]Mn�t�&h���#�����iԇ��C���h_C��t�;g��x��r��0U������ȝ��m�C�#h����^�H�n��+K��;1Q�"��������ѱ�W��+rI&�{�x���@��I�:zY��W�[l
�h� ��i�
�#�X�-�ٺ|��d���%"��+-��a9	]4Uv@����A^����b��� ���]��n�)S�sv��n �h����U��ޟņw�=�Xa���1��k'��k�`��Z��_��oO-������Lpls�qI��^���q�mTB��2�, �.:-�__�
fpmW6��I��Ώl�VT��Tw"gZ�SQ��$�٥`��܇m}hJ�;�sv�e4�Ȩ(G.�dV����t�K�Y�B�c��$��)Y`9]*����{���0a�`)	|աk�xt�\b7��>5�J
�zE���ӥB�)~\���g$/E�r4	�� -����xؾ%��m�{_�oWg����(:�*'V%n_\��������"���9�$<b�3toֆ~J0Ȕ�>��t�GW)�1���N��KE0,"�x���͉�T����@��U�2��X��W]�������ٵ�-����%��0~�󑟂������^Z���></�����r��H���?��ia*�*����[�Ⱦ>b��Ϗ�.��@���dy���W�K������Ui���1��b�'�V=~��!���'O�����2��~ʳ�����ߙe�_�m�T���O Tb	�Iw�ʀ@=_�#���5����g���`f����xi�>Ar@�%R<<��
l>O�j�0p�i�K����/��w��aa�j~7-�ʚ��G�fƺB�G0�X�[19X�r�JF�y'X�e��Lc�yMN+�O�yT�N�GW`&=�Gr����l�.����^���p��̦^� ��[�
��|vou.R��J�f�r��d�P a��u`]�t� ��	�����x�.P9Nؓ�8���;�dp�A�ժD����c9� �.��7.�OTО7Qzb�E&4WX]�a0E�A��qb�ۤU'� @8?ynZ�|*�1]<p�(N��¥�ÙD���pi���h9��ɕ���2Q���GY��b,�r%���,N��/k��N�Jg� ������YG��
d�7?%eB�Lҗ�Sk�r�q��`��� ���iʔ�<I���%Uw�ɳ����`�~,���#	�����`��}M��ɮgt��A���oA�+�����O���Ŏ����1�ۢT��Ws�?Ϣئw\Vq�m܋�aY2�L���Z���HV�uu�j�H��V��S�F��������`<��b?M� 6��|��G�Z,�թ�X!�����.{��:�;�{��U$:{lnλ�B��6@Y�S�*�����g��y����R�,sN���$bS�#��O�-��1h8왬��y�Xm��	����;|�	�ؽY��H�[v�_ �d�ÝK�y+p�x��~){e&��m K(�r��������+�Tm�V{���	�7a�d8��-Pհ�2�@w�z��b����c���uW$��3(����P��*���Q�L6��OΕ����ʢ�L�:������HC�_@2�%����Ƣ?g�����*'-6���z�����&�
���O�凜m	�pm�z�`fƾ2�@����+S�ȹ�$�"=|��eN�ď>���7�Ŕ����x��{�!x��GtqU�J��G�}�\k��)��	Ƌ2#��Y���'ƣ��ʻ��tSӛ��7 �@����B.�|ȓw>C�ݜ��5��	:��.��!�GeI*���jvw���*��>J{�����=-x)qlv�E��G�W5�{�����S,�@M�U�6>{oS�yt���5��\XTYÚ�{ϙ�%�룹�����v�X� �p�Q���	X
>fV�>��J������K�a��z���]�r�l��_�y��!�/Ɂ��D��t�-i��q��Z��U��֦�%��6�ٙ�����[�n�{��s��ap�=�k;} }��G� aa�<Wv��Y<c�v�=z��G9FN睕� �6�ċ�]��!�����|�S8�l��(����N]��oYɛ�O��3�2M��I��Ҍ>&D&��^<�D!is�'�걳Pt��1�7�B��^���b4��v��W5��7��$z7����a~�ʍ�.�� ��h�Y;3�����v]���%��!x��i6�>�O�qQ\�zB�^O�~�.#�iҐ7�{96I->_��m�ay�Q��$K�`	���E6JfS��J��G�5���l'd����Тu5�D£(����h��pe�1�uWA�������{��>�gW���B�~�[��]K5~@�
�g���P�����S���g:[���&�J^�݇�M�)��e�4!����].   ���{WD �>�� �ۘ��g�    YZ
#PAYLOAD_END
