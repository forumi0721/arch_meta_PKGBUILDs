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
�7zXZ  �ִF !   t/��w�%C] 0�JՓ��3�EOS�FU!o�Ϩ?-lwǌ�]V��?<��q?5�<$�($9)�^$r�xJ��D0����������[�������@Z�
t�����)����4���R�uM��xi'�~K7"����c���l_���D�&Վ���P������`���=@B�q��)�k����A�q���EDl.1�U�÷N��~9�!�e|��Yy\�`6xeW�t��}O�-�'%�'b�t�xS��C��E7��Ď��*g��WëQ�Z��J�'�g�2hՖ����c�b��h!��Av�Ch��&HL�t�[_�-}M��qqړXnp#9L#ck���o�n�E��F0��Ѷv�(���֣T�"�hlo]�3J5�\�}7Jձ0�5-�y�'��c+�кCD�+����9]Gw��k�]�y�I���~�=k��2�Fi��"ksU���[	5[��fG����#ʀ~���o,A)���'n����Z��18��X�6N��#�&�IX/!�u)����11��Xn�5<�y�㺽k�"E_��Q��p�l���i��R ����bei#
�؅[>x�ަeZ�*�1��/Ζ�p�?�Q����3�*:.�ʉ�?�uQ����ӌ�c@���i`o#�%�s�|�b���ލV������=��3�V|*�����j�[ l��8ũzP���``�L��rSAN�vJ���}�a�L��L�RmM
�Q�q:��.<VI%ן�%!ˬ���p��4|S<��!��z�;�·����]���݄���O-0�Q�9��wp:��O�l��#�İ�#y���o!tS�6��̣֙�_ieiڅ��x�S&�Eoavb`	���i��7��M������l�M>����vM��2�+�̬�s��T��	��ⲩ��%��wc�o��qV<,c���$L���U�=��Gx<�Kl���-�c�^r�u�R,Z��%������\�)�X��꧙%�&��)�!��P�����]fKӬ�L�O�KG�{���ۑ�:m���֫�oLj��]�D*��A�"�;����g���#ľD�.&���}"�c� ��{&R��4:�H���}v��A����%�;V�����2�%Ϳ�n�Ш�fe�>?8��B�/��������D:笝�}[���+�zR?U��Cj�10�����T��Yڱ�`��Af��9%������Y������!�g^��A��"m��i���P�o!E��Gtҡ3�K��N�H��h�f�?6ck�M�B*�k��01��ŉH��<1^� ������&k\j7�� n2���C���%�%Ӆs�R]��z:�S7C�����7"q����}�I�""���ת�A꼔��5��{��}�����(�~ �vX���q�ᅶ {
ȶ�l�|���r���x^q�֍�ɞ:��Sh��}���i�+AX��\�=��{�y�#&�ӎ�t���d������"}�e���ꂰ�{\�/Z(�'��p�n���L��qN��&���!
��f��BfxV�Gv
*m��������u��)ˡ�n-}����=n�1��UĖ'V\z�m������P�7� ���Ϥ `>H��z:˹	��~L ��Y��o��K�K�����k˾%�,���5���K�N6nClE��+�|�9�T�H2���D��F�О�U���t�����N~��|��#��ۿQ�jQZY�y̠��b�q����f5e�����)k�c_���g���;V��`�v*�^Q�޻&����	d�hFW�v�+&/ �K*!(���j�vЬы��0q�������@��ʬhc��גw#%N"�}Œ6����*8`���]G�Q�^�*���zuo �-����_Ӱ3�d���D�oP��ފ�z��D%Ⱥ\䗠!2#�W)(Û���m�����q��?�h	 Bv�JٕB����?AW��}����-G���h�HA�O�IG�r��X���.-2Y��[~���PBB� Ȳ B�2kѵkj�S+�R+���yϮ���sĨx���,y��A��`B���>���rjhh���|8pD��`����/#�8QX��"�6��<t'Äs�3�칤�0� ��Teb88�'��9ٌܕr6��(3�]7?�~�	Wť[��������mBR��0CFΒ�Hî��4LH֬'�R�\xj�Lo�p��$�E�0<��,xZp�ţ�چ I���������E7�wy�	���i����6��g�y5��5AG�j�`~�^1�G���<|��zD���pK3�i���ʓ��+��I���k�J��3���v�9#��-��e�[0�Ԅ�t�^������� �U\��9r��el��I4�( ��8��%�{������~nAAD�fY� v�����#7�^�̈���g;,��H������r�F����q[ �r8c�?;������>d�a��fR
����	��9�G˩ �=܅_'⤿�D��;�0�!�F�����`ŏ�
���T��a$<�Uk�+fa"��{���@�=�2�s�k6���a�p��&4�.��*&�k�f&z�v�y��F�J<Q��V1�^5����\{}�����P�	��b��J$���?��RI�jp�.k
>E�z��O`
�~�n1J��QD���i�-����7��c^vo�cQy����XE���O��|h���Ci������>�<�˪}�ۍE���[
����%��iHx�j�T�q~c2S"��j&��Z�N�R.}�;_�h�f��� �k�}�L���p9D�]b�]�3Bz��G�u��@��5���aEj�{�og�������TU�ŕEI[a��2��x�ޠG��@_�>=�i�y�����"����	��n�r+���F�Y�ܜh�c	2���P�G��Qr��*_ք�W�32 #��������������4�ѺiS�:��z&�?��S}U�.�{���<OmM�A
�w�x���9��11��g�
��$�^�F�|�/Ll�����`��<�Nt�=�Mo����-<@�ʉ�]�xD��~�`3(��~�+�@�v7��u�j��j��eq�M�<�Ll�c��8U0�@ʂF��-�n�.�ePC�%�d&�x�pz�ww݇e��ʳ�]i'�������E�V�I�����ߗ�5��d!Q��G�記�f>d�$����a�Dz�q9���?~��6��/��pW#��s^]r��,�)`޲�FE}�j�ʉzb��p�,/�fu�$�-�/2&ީcT.B���E������t�^k����8�����P�Uy_GeM�٭��q��/�Zt�a
2Լp�돠ծ4�;��͢ϒ�IX�6m	pT��k��{��zw%�O�?���I-�TM���l;�%��s4�p�1�J!x��-�O����k@�i�Y������c��@� �0o��o��^;z�z�H��k��>;�Ml��J�+'à�ۯ�����2�R� �ǫ�E�θ'�H�}�,�i\�ȟ��r���5�`�-%��T6~m��1v�V_�_-j�{*y��x&�����=�Ȑ˖�b�xD��Q��'���c��H��Z6ڭ�mL!�Ip^wڤ� �
m��?A(�B������γ�fQ��j�7sӚ�E�)}�dÂ؋�̗D�Mv�������I�I�w��F��5ѽ5�����k���u2��I6J��0�>Ͽז&���8z��6�4�� Ȫ��%�{��`s�f)������9C
`g��B揄�?�����8nb' �}0������"lZjB�#�w�Zd,�}60;�����[z�PN}�F�滼��o�}P�w�K�||�F,��
���á�����gZ�կ,<���	�R�s]�ӯ�NT�z�X4���3����c��$T����Tʪ�1�&3�o�ǖC
�i �!!��%��� ��A({�Bv'�p���_2ͱ2���L4�H��tK�&M�L�0�6�
�eY;��[T�#q%{(��z0�1T6��o�QX�2�IӤ��@�/��V�L*maƖ���p��K?�[)�����2���֭��r�_��}����b.E��΄�[9�'`��l&�`hw̎�*���B�Ym&9�7.����lQN�S�l_�!f>�>)������u�J���c�׹�����B�Ț��������I�$���;+i�%������U�R����G�:-�|��@\��= �P�>Ec��Ճ�\����-�b�CЙ�3�82"����\뾻�OQm��$B	��Fv��0Z�zB����p�k�����m��v^}���)(^wߌ�{�Q��C��R���RyՐ��_�mJoY�-e��_�G�	�D5N#58o��~�����3xojqC�1Eo�J|��	��h�����}��������pD�}������(a����T;M��s��,�A� ����+_|'8b������͉�v�Ug�ҡ��~^�P^�;۫A��J�-�_w� ���y�Ҍ��������H��@5o�0��1#]mf�~�8�x_1����A�<��0���.C������)�g�5��@�y�y�(����>��8�4ÿ["��d����&w�������!�njA��"����s8T��y�`Ɍ?�.��	�[+��Xtq�+C`��d
b^�����n+�l�"���Qb�$}x�`��>����k�e>�a�P�p��L��Q���(���Ae��2�lD�&kt�3S��SX�ZMQ�9Z���c�cT��E�RL$�.��L3�Bl�`W��m��������GQv�;bAK��a�Hǖ}��S��G�y��z+�q��!�A�O�`�b1Q���V�_/O�f��a���]��dN��'�*�D������_wHUgB��ڦ n�����r�ܲ���d��"3���������Hs�JO���+��΍D@6ͿUo��������Զ*	�>)�R��=������}���9e!\���u(�����_=�E��b�;��a3L��hZ��Lj��A�+�lMB� v>�6�W����q��	*�?�\��fد�4�iy��86���a>�+2
��Q�N��Y��߶��Y�R�6K]?_����?B@�U���c m�Z8A��X|,`�z���ꟁL��ϰŠ�Z!��bwM��N� ��wXt�PO������3;]=�K��&Z%��x	r�A\�2B*h���J(�Z�
.��<�Ͷ7&�vew�1�9[����&M�e�M���� �� ��e��r��^_��
�	��/�4I�f~J�1��e>xC����l�eh�v�G�
 ��7�$�Q�3,~�o�{w��g�m��I@��H�["��x;sH�͚�H�uw���
';):rf��S�嘟6ոs#�$ak�_	wC����
�Ϧ���{�v���Y��!ݲ�f�&S��/�7��s���ܑU߭+�
?��G���}P#���m�{�ԾP�N��ppnodW��3�m���t��0����^M0��_��vl���֙�]����-�������A����f�O��ڙh#�5�����Kׅ(���B0q%����
�C�'ih
ڎ���f^չo��8ċ��[~lTΉM֍W��h"�b2��.W�Q!Z�g����QזA�UF��DƤ�x9�_��j���y���Bz��'�X�C���k%9�5�B�W۷���F��B��!F�{������5���Q`u�܈��r��%�u�mL[������B���\���4�$�~z�uyxo(8]�(�K�����<���og%�����F��_s�×��i'�#�l�2(
�ri�K�TѲp���.��:op�&�0��k��^IF���z�*��|��H�Ȫ�h!� ��ʌ�HZ��\�H��݉�����x����-��A���,Q�z0�2ϋjQ�8�e
]�8���#�ָ�����!T0t�_J�х��>�+j'�Ȱ-���+:J��	�3�e;��x�G�<��h�
��6��UF�`v�yՎB�4������B�W���aCBIy��r %�=� 5�]��J��A�8������J2�C�y-�[ĴjI1r���J3ʰ�tWz4�HY�����b�?J��.W�E;��Dx�nT8��|�@��S50Lt�K���j�>A�5��;�_X���� i�^#/�`,�f����<�C+ a[�-��]�������J�Ƶ�uWb0±��H�CKٕF� ��SK�@�43�9��?!�IY��0���Ǽz��h�75��5�+���nw�� ;
��=���YJPص��X�-ⲉ��6��`[~w H��5ǟͮ�!K��T�{�|�F@�6���;t�.?e��;�{,�0�4�F�ԧs�יoR[ۉ�OÑu&@��V
��`P���8�.X;�b9����ji��7�Ǻ#��� м����w����5�l$r����NL_G�P�f�g����U�V�������C(����� �)ł�����>�7�������X�ܲ�ȟ�3�f�jH����=�BfI�Uy|Q��=_L���C3��+�&Fc�H�QƬϲH{d��b�����y/�v1�0�U��b���ĕ�l_�D?�I���K�}������� 8����ٴβ�2;�09-�I���C�-h`��[�N�G���}rR����}%�V 9�S�8�I���H��=�������3�̠}�� ��r?́A���	|��(��JIgY��}�bn���7�CF�-��䨫��Z)���;%������m�b/i��A"���]*�K.���*e�yt�a95�{c�����%�!�S��[�JE���b�$������|z�����c,�,���h�>D������ĵk�~ٺ��ӂ?�	Re��0��`2�(ͼ�8f�QD��
��h~t�%W�����Jd*�n,�_P���]ԣ���T�*1�A<�jf=�@��;Fd��������gG*�l�i��=�w�DwS�^U��pmt�ef�E47rG�DG$�ˊ���b�j�MI��ʐ�8�/}��E��i�K)����x':�����Q\�4m�0(צn�C�~�� ��v�z\��ϾZm`h��tJ�(�s�*R*_�`C>�#2��G֟�)����g�)�g6\e�@�T��_���D2/�D����ҳW�H���tIf�T���un:��N#:%0Uro�Ycs�E������I�; N�;��9x��s�?� ��U�0��hn��+˾4�j��at��1�(��,�R3� �c|�v
�׼���|�??��OR�Q]�52�.�*��#:S�]���w^�(���'�Ldy#�a� @LaԜ�	��;�3/zs�eam��g&�ޑ~[�*l����� ��`�P������-q%K~"w��6���I�Y�!	���mI��?`Z�C�)��G|�V�1S��?���
���nKS��٧_��Y����-��|�%7߲Cn�D:76�UO���Zq�/����23��־VC�"��(�C������MR��U	�S#�:]�pw2�� �j��OXi�r�D� ��h6Bo\�0c�� ��N�Vj�=w$Rs&�f@�]����Q�_ZRkft�l�7Z,����A���e��q/Ⰾ�� �f�G)�h�1���՛'�X6k�i�����z��,X�@o3"L�H�=7��k�}�[+� ߑ�0�
�빦��I�;O�#驘���FWyicr���`�[�ل�*���>�7X�x�S������,/����$����R�����#�ę�ǴW�������z&5�J��x�{�=�B���t��(��<A: `^����(�q�� ��H�T�i�'��unJ���	����l����=m:�,5^[���ǌ��<�>,�8�OG݅[m�-��������uʑZ��?(��al��ec��z6���CPpq�d��G���^��0o9��xg��@�v>.C�N�>�9�� 'v?���1��` Q�c�]�0O Z �<�Jݥ|�F'zB�c�{��Z�~�*ʽ>k�A�)%5x���7F��[I\Ն�ba�A���3���)�=�G��c���=�����d��(~�7z��	���n�첂�G%V�(�g&8���z�U�)�+�C\RqG�Y�+�p�6r�Y�5%N���k�IU�$��<��XF�q��!s����MG��w�Y����pf��y�����c�v�A��w�?Kr)O�`Y����E˫ŀ���A���9M�a�d���A/�И��~L��x}����"�Ś:����3�՘����_�� ���}��r��K�I�vJ@�l�����\ea7����t���?�u�DP�������ÜY�m�ٗ��h7W>P?/�uȥ���^5C�!��� T�위�����M�yޒ�����6�ʟ���U�Ќ�ݴ��<�`�W񶙾�Jw���I�f0�����2�p�Ԩ��3�s��:��0V�1Q�k��gj������������Q3�P�,����]kx���]��,��ݕ�w��a�R�:�)����iI��V��5&Q� XF�d�U-�L�RfTm|�.��b��:VgƎF�^)�N����t:�F�3I��/02M˅���r�0ۧ,�����ηM�2��f�J'z>�#ce����Ѥ��/ɦ�a3��!`oz��2;`O{ab�����׌��և�o%��R�����lf�M�x��+�CO��.Z��A�u�_4j��*ǟn^�:`������x�K4��s��{���\�	��?S�s7���%�GHw���H����4�/5n��!(��B~1_���ޜT�4ҳ��tPA	Jڞ�F��T9#�l��$���E�}�:Guf��!A�1�i�&����_ڕ�5f�����.F���.���#�>�u|�㉤�Q��o��N�h\��_�>A/���=R
�=�`y�4H��u��l�l��2J/C�������D���d�O{R,����ɭ:
������թ�̽����.XF�\���j�m����-��/.�\�lX�����TER����������&�_��l\��E�3�U�L�?I0�\.0�r������Q2g��b�?Έ�!���@�I�j�f��� ��( ��qv{lI01� �)��F�B֧]�D[�!���UBF	\�:	�pr�S&���e��|wlJ�S<�+N�V�`ٹQ�����]-������'G��O2��?��5=�;��re�D����[;bSK��[���82�Jpڗ،���᫫2��q)nB   ��E�{�f �J�� e��s��g�    YZ
#PAYLOAD_END
