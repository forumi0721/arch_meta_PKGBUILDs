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

cp "${temp}/bash.bashrc2" /etc/

cp ${temp}/ssh_host_* "/etc/ssh/${key}"
chmod 0600 /etc/ssh/ssh_host_*
chmod 0644 /etc/ssh/ssh_host*.pub

cp "${temp}/sudoers" /etc/sudoers.d/

cp "${temp}/vimrc2" /etc/

mkdir -p /etc/skel/.ssh
chmod 0700 /etc/skel/.ssh
cp "${temp}/id_rsa" /etc/skel/.ssh/
chmod 0600 /etc/skel/.ssh/id_rsa
cp "${temp}/id_rsa.pub" /etc/skel/.ssh/
chmod 0644 /etc/skel/.ssh/id_rsa.pub
cp "${temp}/authorized_keys" /etc/skel/.ssh/
chmod 0644 /etc/skel/.ssh/authorized_keys

cp "${temp}/locale.conf" /etc/

rm -rf "${temp}"

#skel
ln -sf /dev/null /etc/skel/.bash_history

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
			for s in $(find /etc/skel/ -maxdepth 1 -mindepth 1)
			do
				cp -ar ${s} ${h}/ 
				chown -R ${u}:${g} "${h}/$(basename ${s})"
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
�7zXZ  �ִF !   t/��w�%*] 0�JՓ��3�EOS�FU!o�Ϩ?-lwǌ�]V��?<��q?5�<$�($9)�^$r�xJ��D0����������[�������@Z�
t�����)����4���R�uM��xi'�~K7"����c���l_���D�&Վ���P������`���=@B�q��)�k����A�q���EDl.1�U�÷N��~9�!�e|��Yy\�`6xeW�t��}O�-�'%�'b�t�xS��C��E7��Ď��*g��WëQ�Z��J�'�g�2hՖ����c�b��h!��Av�Ch��&HL�t�[_�-}M��qqړXnp#9L#ck���o�n�E��F0��Ѷv�(���֣T�"�hlo]�3J5�\�}7Jձ0�5-�y�'��c+�кCD�+����9]Gw��k�]�y�I���~�=k��2�Fi��"ksU���Z��X4�A��3���j9qXٺR���� ݯ������dqR��|�[Z�0c3RS`�~�5#��.:����?�&f� �ֈ����D��E����a�U��yv�/�v6H�����.�&,nyz��j1S�rJ��˧	���!�ұU�:)ߌ�7��2�s��T�9O����b���� ?5���%#"���p:x���r��F<�����C���I ��:�)ḡE}���lE\;�[�Mvq.��F5����.`b���J=_�c@����oY�DV�.tYa{�Z��Qx�ı(c��4x�	��|�U��
�ˆ!ԫl(o�Y<��p��i,�튫n4�;	��eհ�h>9zZ�{_�pgԱ]�N���wy�A�M�4-M�^�4)Iv梷�_�3#���PNB��	�D��ۄ�ērwX�������\hz�ݾY�
;���La���������SfW�n�<��̫���:(�9M�������~$��E�
��I��r�B��u?~���۵��A<W�~59����}=�l/��ե���zS�	�է��#�Tzd�Ю�Ag�f�-�����e�*�C7�-���r�Y���2����VCOb��n<^��ZO�I�=���꧂ci� ���X�5X����Vg&�TJ����,d�`G����c�'�
��M��
h�?��99T��wr��,�����Q9�)�H�%"��o(�z/I:�~Wn�BPK�nɼ��m�����vw!E�x�V�:	�@��߬�L8;���
'C��^�r_uFs���\چ�B2�M[����TʷQ"�o�����t�D�d��ϯ�]����@��N\;��&V�4�l�*`-,��Ȗ��{ۚ�.���s ��ބ�@��(L#)y�?Z!ʰ���B���;�`�Lڴlw�����q��થ(��Ҏg��RPf!4d=��j O��`y.��Fᒩ<����D�&�ѯM���
�P�fo���wS�m�?�?U�p/r�!+J+����A]S�,�il����ǽ8V<�30w.��1���l�*I��p�;���0�@@�=}(���ҤJv�h��O���G,�4�A���Q=J���A�*��Qc�Z�^ޭ�q�Et���8CUGp�:�
��c1*uj�S���G��<VU��.b�(l�GmT&��������B������,쮹�S�՘ޛ�?��D�u:����p҈5�&xi���ͨ�ר����' ��q�Cb/�P����.��N��x�E5(TJ�v��:��W�M�f�/&�z��+;��H�G�`W&���n��yg[3�_?���L{�`�K��p��Hgp60��x����>Nۆ�D���8N��{�����h=��V���-jT�����F��eh�����6#� GI�&[x���]���>�g�/�r�Ox�f�U�Έ���^f��D����]�o]<ҳ�[.5K�u��$Ș��k��S�+���5*�Er��ґiȇ:�q��xKQ:�y���\��Ą�Jsܢ�B�}�E�z{�I1�\�LЊ�B��??�0Ex ���.�C�ɓg-B�P����E� �t�G{Ù�S����^HA�=�F���2����[YI��d����*`7��P5��;���"��dfU�O��zU1L���^+|��!�Z�P�]����Z/L���n����/C�b|�X�*����Q�6�?�5��T2H��c�-W���5��kcnvw�r��v��J�PW���".n��̗]�;�'ԡZ%����a������VB;��6m�Y�:�\p���D�*��������%��<���}�7Nx���-�{�h���/q\f/��P]���QB4H�X6�����t)q;�A%���,��R0h<E��Ia��D�MC`�+!ۖ��3�&l�[k��e�_�04K�:��lFA��[�pAN�[�8�|�xp]���|=��
$ŋ���e��:�i�֫a�@�gV��/�~T[��'�w�P@Q�N���t	�0��%dA��+��!�c�B�f�����N����򘧪�fߌ��;�q�;}
�h�q&���*�(�&��^�4��,x��݉;Ւ�x?���� P�	7�n-Y�{K��	�U}}�)ڰ���`�HВ��g�TJ�I���`ʱ�&� �����U�E��>3	��f��gw��>/��������H���^Qڬ	�`��XV�;e�_Zln�u��\���>_�����^�D��y�^�Nc�i�p�&^����Jv���0OVj9��^�� ���x[��ئ%[ýaU@6F�9�=�y$�,B�8�ǾV�3&�����S��M�����!j��gʶ w�]p����  3���岓%��(�׹Q��)�q���)-&�
b^ޙf���0��Zc��N���S��G/���L]�x%�RT$�l�w�7��RE�܊��Xߠ �{�<��Eqv(Է�X'�������2������qV+�q�$�x�'�Р�N�k�wӧ�~[�*>�(�ʐ���"��E$�|\�ݕb�F�r�U���)��N��JX�ɽVik�=�/��gYz+1Z�KuD���Z��� �z�ɛ��r����Fհe��7����+l�p��9⒩�FO8LW3l�U��|w(�wQ+~W�)dVQLV�5�h<$��Ʃ�6�{�Q�̍���҅b��l�o�����Г8XΌD��L�ݼ��߬*�z� ��	�����E�F��+��=0)�{�P�mp����i$!mP[��k*�TV�����C�M��Zp�Q�K����w����?K0}��h����ł4N�T�s��T�Q~��V�4̹�ʓ>6��B���P����,4�[N��A2B��c��1؂����S���7����z,�_\��pŬx	"�Zi���r���/a^0I�X�(e���+�+��Ր���',٭ҰJ��i�́y�IW�mHE�Ja�%�:����?,2��ю���0K�d��U�A�����D��HA�����5wY��k����і\*��j��i��`�ۮ��n��������ഈ�``d���5�7N,0��R:ϴ$��2\����Aj�P`��W���M�BF*��w��A��jRl�K���TL�3I���y��d�� G7��Љ!,�t��,���D¡ҧ메���:?zB����6�x��fLx�V���K�v1,>�8�+S�{�M3})�8u6���n/��{fF�w��Cўa������[�-�(�9/�㾈�GB��8��d�Q��T��`4��i���0�ы�(�\r|�'�vn���@�T_�(S�	}�;���s���~�0�������9�2	��Z̥ �1���Z��P�p:�����=�	d�X4Q+Ө~8��/?K ۠��փ_$���#f"��+�N�\yu��gk
��K��Y�P\�M�s�~(j��׍�:�?M��w�z�Y�P�|��σ��[���5��$-�K��(.��F��ޝk�ۉ�x}��tBAc�Q���(��*0eh/���h��V1X��>̛ԱN �\Rw�2�����ȹLXZ�Đ�vw����F䌂��?�G���i {X���@�v��8\��x�]�ҏ���N�	J�ߍA���lC���m<N�(J���u@'�e��vUs��`(Ѧ$
��F�d�9�o�^VK�xI(��.���zm"�7�$����vE��_���c����z��Ҡ��v������P�݅�0}�N���Έ�,E�x�
(o�3ex!VK�^И��r�dB�T<������O�y'V2	Q�+���G��.<�����ǖ�`_�+��amx*%�&��`x�2!��
M+�jXT��52`�u	~��U�\C�m(}D��	2Q�?):�6�����l�xZ�j���k�j����	sϿy��+�ZO�$��\�|��?���){Z�6(�z�h��_�!?P�0���Q=5�wG������'&��(�׃��z�=^���]v=N_�~��h'pW|�7�^�fJ�"��J�`
.��k�r�����j� y�������~��:�4Ҡi<�/�'��O�.n��Y�= �݃1�p�5���0v��g�0���f�<(`H�i�2�}�@�X�p?��AL$@�������n�x/�~=֭�G�V~�໪��3Lr�B�w���,��f� �=頶��H�×�9�&�8ز��OD�or���1�U�/�i���4ƺ�V�<�
WfOT���DW���B$;� �c�67Q!^�C�N>�a��/�Z��F����i�(s"��"�ȓjI�X[��#p	0DF�7B�Hē�ӌ!���mXz��E$.&6��ő�=G�#�/���̸���4�����
�����ƙ��Ԯ]8�Z�,�tG�JN�h�`�p���,�!��̇�f��ےL����N_o�ªL�@$I�"�7x��ss����iI�����gY9�������$cxR
(K ��!�<�$���n���,�.:tr�)5Ι��10��,e����%d_ٮ])��	�>
l��SbŌ�f������r��h~<>Mivx���2v����j��Uv.��L.l�;�S�� ��;[ ����c�zIJ��+�c:;X���Ȭ��о���y+�.�֛s4��2�J�+��=�9��j����M��$JSG�@����m���)@Kfu[2@�畯f!B�he�*G[)��S��hn�,xW�n��[�a�s7�#��J�F/bC/����Ot�t�t �)�O-�<Lk���#��[1�'�9;)�WfPK�Y-K>M��4Da�����bС�:S�3F��y/x��u����ݔ|���Fw��6��%9;�ߐ4��Y��0��>�〙���:�A����Gk��<FƁ� ���~4T#	��r��c%�2��s[ec�����e�]�`L�[���`��Wx1�V�௅�ʤ>��%���A����W�`���!Kz+�`��_o�ފW� �Dv��P}Q��n(���
�Av�s�>�n�#)�paBH�]����	ij�.D)���L��&f���'�mo��SSs�=�j���볟aS?��s����{u��r�"ݓ&x�����7 l<�!N��[;dErg:vw��W^��<�}�Y �I�c��5����m9�hՇ�΂����T0�a#��	#��0)�ت����j����vi�k��Η-ܟ>{�w�����S^,�9g�=k?ƚ���M����FN��l���*�Vq�{/����/5��7A}(�X�*ோ���8��/e�ieyQ����2�DD*��X��ᯈ�J�ֹ _]�C��h_/3�_ �Y�<<��p?�6:�Z�w'���G��$	��{0sK�<�x:%�.#�pB��b "�!#��-���e'mg�^����S��B��%�����u3bh�F������x�9:��%H{�k�����=i3C`�Ӌx�����QxK�T�"0X�Ǎ�K���ڴ<��ސڮ9B_˔�R5�����u�A������^�<Km�=yK�Y\ciN����Q��&,C�Ow5^��4���,F���9f��湛���%"��K�^WV�0����ՍHY'�壜��DCkEs��	��rX=��/&��[ue���D�@� |>�;C>ɣc�0=l'PhSd$�&]CpZ���$����z8$A�=䱯���dқld��m`����@ y�i�������0��n|��Oo�V��گHM����]����ԐR���$�a�Zu�0�4�¸��I.h6�E�yvƈ���.K���QC��d�26b�p�~�+<(�9ռk�TA�,��z���v���-<A�{�рV4�_�XA��z�O u��I�K+>��EDRU��5$݌d9a�0���aйiq>���|J��@zV�V2�G�(����*J�7�ڕ�o_A�����H�Q� n����J��}��д�ptf�B'�d������
ǅt펠��D���p��X-$�gƞ[MO^�D;-�u��l��L���?P�'�s����V�_1�9���dnRk��#U$����8t�(-�,��x�|����̯V��i���6�#;^��&(�YQ�訯V�ǻ�~ګS�h�<34���v�������\�_���7��	$�Ɠi|�l��M�G�7�2}�tY�N�ib[�@��JJ������V����������Ka5�zv&x��f�Nn�؀�bе�Ȟ���	��wܔ[�����Jƻ��ӵ!�A��3[�})lZ��}lb�������b>� ������(4���T�D"e���Q�v�iz�E�D�i�M�!�j %����jj#�[���/q�]��5��дc1�I�����@"��A'�&�~�����y*{S-��h4��!���@"�:s;�[��\qfJ{:����-K25t�
�� ͝S�p����[<�����"�.�M�_|ٍr�}�U�=E�2�b�!�������^�.T�w��nsH��9�e=T��$W����Ԣ�b'=w|�]b�H;�U��{�K%�k��I?N;<�ϷO�?6s=��9¤���k��yu�$�R~����=bg����$�]J(��cCH��<�&��������NU��H4��)w8LWN����}�a7"N.j��YD�/�f�e��v�R�"��4�B��rF� 䙼��P��ĉ�����oCw��}���< ���Td�i19d-D��m�4�o�l���bl�ֻ�>�A��ϘcQK	�#�N��B	'e�č  ,��<��4�I����q�Ӌ�g���7Ki�Q@�kv ��G�[[V�L^�.���
3�r������h
���c����"_�8nO�w��(|~|p�J��sn-�NԋawG�m�O��wi!��r�>5��Pw�省Rq�,�	D#*p[�� ��@���	GkB���s��h������P���>��k��Ǎ��⯓�aFВ咂�`fRs�4D*+<\�ʄl�o�I��R���޵�s@ђ��x����|��暤O[S�Y�Z���O�W���o5��n`���N
'���(��"kz,�S��nl�Bx��&)�ƪ�@�|�,�O���I�[rTݻ��m[g� �g~}�	]��v_`-�%�K�3Knjpcȵj�0��|>e�@^��]żuݶ"�~"���J�Ynܰ�F��}P}F5"\��tյ���L>c�7	LɯN��Q�	���:���V ƫ��;�ju��{)���D���-���f��Ը��m0k�hNV�m����c�wj@���Az�B�F����
�_��s�qFu�>.#�-�����FYV�1���������Cs�^�X��zn�D;����3��Ɠ���k������&��S7e�/�%a���]a�=B��	b�0l$!H}�7	~��@��4��C���>��j�����x�!�J"oDHoH���s]ݺ��U(���UF�����1�ֳzj �+`䗥7�(w��z?�b*�o��=�9˥z��c�l0�!��w��u�Quc�ߓM!0��#�Ò(�j�B�FK�}��U[x-�'	�~$�5�����A��
��}�ƻ��A'��,h��xן�/.��֣`7����^6�3'�ѵXn}3n�Sƍ<�R���������	�����g���S*��Z�[+Y���>lR�����y�K��r���P�Ͳ�k�򒓍�1B7;�^��D��iE*�3D�efyrj��['A�5���ad��Զ�ظ_ҝ�#Fpe�X2w����J�s<Tf�px�1�!�$=���i�v�{��a~�Bk�9h=Ȕ6o\|k�w1qA�E�o<튂?͟�y������-�9�8W�4�јhiO�����%�q�VV=�#���^o�_��.Q͕�]��{��!]��Y\�M�f//��J���w<��;.�Si�=�A�Z\1b{��m�wQ���IT&��#��lN4���⟳T ��ZR�����v�_
A�7���P?M!$o��=���i�G��s$��^�acTd�C��дP�R�!RR6��;��K��lkk"j~`��n�h4T��;_UY)�c|�hج�B�	t֊��mc��ZD}Fzh0��<�kR��I�����
n�;?4��TM4��+}sd!O���� ���Z�e���n�D���S�����|�s�G��LK�T��w�x7��6dȹ-��f:т�VHG�W��@��?���;�g]�C�~7���~�7޹��݀���˧]2^ם�+�C!���8�e�:R��Y�[#ҫO��vKCy*���Y\'X��['���m%ﳮ�K�P�l[�xJYw��ƌG�β�Q�xwk�P_�Ӣ�ȟ��N�t�x�#vgQdu�H)h�~B�[v	���	N���7�:$�%��/��\~l��P֔������Veq�ǪIɇ7ۭo):އ3�U3�B�B���훦���$�o��L޷`�v�e��N"��T5�
F�Ӥ>�f�\��	��uz@󂡪E࠯t-�E����:���J9+:j�B��������B�}K�C z�����6 �;Ӝ�X~��l/��8s�,\* �g̢��ӧ���&�'�M�<bT��3���ڣ+�E�B�V'C�y<߅���~�遛�0�s�;;_�dk��x��{k��;�g�RZɁ~C���@[D��_����(_�4�Ew63��u+��T1s�f[�A���'�o�L�L�փ-�T?;���%C���l�k�#B�gP�`���r�8P}h����x�iZ�ܙ]�@˴��~��ˏe���VY����C�*�*5���x�W�o�2����/��(�LllL;V3��Mn�    ����!5 �J�� 6�!W��g�    YZ
#PAYLOAD_END
