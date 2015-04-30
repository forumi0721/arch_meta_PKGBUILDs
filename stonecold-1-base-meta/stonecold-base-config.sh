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
�7zXZ  �ִF !   t/��w�%N] 0�JՓ��3�EOS�FU!o�Ϩ?-lwǌ�]V��?<��q?5�<$�($9)�^$r�xJ��D0����������[�������@Z�
t�����)����4���R�uM��xi'�~K7"����c���l_���D�&Վ���P������`���=@B�q��)�k����A�q���EDl.1�U�÷N��~9�!�e|��Yy\�`6xeW�t��}O�-�'%�'b�t�xS��C��E7��Ď��*g��WëQ�Z��J�'�g�2hՖ����c�b��h!��Av�Ch��&HL�t�[_�-}M��qqړXnp#9L#ck���o�n�E��F0��Ѷv�(���֣T�"�hlo]�3J5�\�}7Jձ0�5-�y�'��c+�кCD�+����9]Gw��k�]�y�I���~�=k��2�Fi��"ksU���[	=���X��Jow����W"�5�ڛ5�M�~{_2Tݖi���i�IK��)wlJ�	�e�J+�xi����6(4�}̊,b��Ȕ	( ��{��UX����d<����h��hOѓŻg�+ջA)�a��C�嫲���FQU����e(D�$��@o��-��n
���9���ް�Ѕ����E4�D���Ƶ���iq�Z�����2=6{r"��5%�J��6J���;R����?�H��_���J�W$�"�X��ڑt�q^ �ۑF{�ћ�=23ɏ�9WA6�z��KH��i������-�ǣc��B��%�`��e��P==͜�١�gS�;u��ӂ�6	���@�J������^�w���D#�5�����&{��H�{����10C�q����{Z����iLm��q�	�$_�1�z���3�WX�L<#&Ӿ��<w9��S?~�Ѫ�
$��=#[*qp��4�k�l2;�z\���4?��u���7v_C���@+�>u�}+*M�;�D��ۘJ@!�j5�$_�K\)�/�ܼ{]��q~q�yDDC�>"���ʮK�w��E��p�=���Eډ^�"u�ء�%��ea?���lY���?�c>_�>��,+3<X��ڿ��C�\�S�l|rVe�dw?�F+�Qz����.暜���G����)<_�*��:�����Á�)=OjS<%;� �X�f�C@��hN6cf��:����paw1�)Ñ3;i���l�������O�K/�oDQ� «��2�$ Tʻ��m�G��#�8x=q�d�jU�Bk�=��Y���L0@�4����S�h��E�id'%/�n ��O��ij������v����E���%���૥#�`s3����.�Ed�D;�vz�7�D�����U��6�R�j�"RC�ޘ᫧G�}Tu����%4�H��]�ڔ�G��X�����ԙt˪B����)��va^�u=d���j�K�Z�q�悘	�����x���/�{u�K�G��ǈ��n���)�c<mo<�-q�cN'��m���#�&(�fV�!�X���^O��c��4IL	�?H�b'·�+2���xv��k�9�r@�D��N�E��F�xň��]°�B�1�}l"�t'گ*��n�1��;�9�����i�5�JŘ���)��&�]@�T�̳x�6�"NW��r*<r�/��� fF�ϵ�ҍ�PX�*d�i�����C=��.\��Fp���Ӫ~��k� ������R�~$��B�n�}���wl�� 	&}��a ԋY�֤4�����Y0�|��r��8��K��@����0O�����4q%m�*�֕����x%B�~�A�
VM���?����k@Sm#��	&C�j}ϗ��u �oy���y0�)ʉ����c�,��u��I��-��]�n�t��C�@}�k�d������DHu ��<H�+���t5�5�Bmp�g��I��Ln���hg���r���k�<�P�l�z`d��9�2�{��8䜘��]M�h�M3t�m#�/�s	t��E�~�:�P!�Z�t���:�udA�+���y��b1�<#Q��'
�/��d���|�74.�m���0�
a:���T�������ɰ���Þ���&��\\r'-RmYd����\[ˤG&mP� ���Z.Z�7nֈ�#H��$b��e��	�=E<���#E � �~���e*�ą�>�g�ǩ�"T�Ɩn>����u�4��,5#����RUv��2����9�$�b{��' ɇ�<dw�ᴟ�����K�aKv� �=���6Ke/Z>�V]s~3��1�(�@
[ꖶ�[f|��I(��^�H6�/����ﵤ����~ ���q�啧�Qxx�����wwV.�1�����m�\�r�FK�)ĺ�@E���.y,�����N��B�p�x�"�h;�&�[m����i@�&��y�=��cpj���8�8꒟��.�MivM�]����Or���e2Y:$��{Dm��>=��L�ɗ�8�Ikr�r�\JD�Ps��^�د�2/_� �UZ��0Q/�>A�V����P�� ��سӊ�ƥ/:�2��G�D��B�G��D��K=R�b}��z��"-
���k���Ss����N���I�Hp����E�������;yV(������|ua[���d��gpi���F*Teʣ�Fz�L�Hֈ0�����.�;A:U���lUۂ�����0��IAk��/��,4�,���Y�d���	����m��n|c�(6Y���҅�{��.�Rm3�
��Ws2�l���y��pU�G�9IT֟��I��	p��M��3ٌ{�R��@ۂ �[��2�홺֊�ٕHk%Vb��iR ���DCQJ�e�2ʪ�΋;a�-�܊�{L��):qx�}~�O�
�v~6�ѨΦ$>,yA4<X�6|�1�ۧf��A�lP��!��L&�.T�|�)LK�O�<y���Y6W��د�F��Xuˤs�EF�O�����jD� L"3���F[R� �b!:*�i����:^$ !��O���2]���h�Q�1��(����)�����7����Sӽ����~�����05)O�O�=δ��=O�Z!�j�V����w!v�L2���H�`w ����p��J#J
w�&X��N�Y�L�
H���w1���4# W�	�0dAd��ي�<�ys� �M�v(��-��	�	��ŏ�e̥�mg���b�c��gmNt/z{GPM$By���p�_Y#������
��,G�6��s�o��@%�t�Oeճ4�i�{^���r�r>���C���ܑ�p�Tp��y��l�ob&#}v��(n��YP�O<M��%	��e]o���{�e��
���Ô#P5גR�Iz��FX&i�̱35�?���BMTI��ܒ[H}�ۭ��" �x�����-����U$bm7$��S,;���n+�D��f��7h����4E�&}�{�?���#m��K:���0,��7H���z��"4�a\{��+د�|�,� `� �kh!,��O~�Ǥ;�1Ҙ0��Cz�>�x
���s*�{��XCB��d��#�o��m��tK�>�g�I���}����40�I[���]{�ޯ��m(�o ��!r�n3���}��0y1�_� ��[��Ώ�M�*JX��o�{�hp��X��Au��H�[��+ncf�pt���ݣ��¾����������Q�Y�$��B4иbJ�q��X9�w׺z����B�|�(v�^g����.HT��2�91��i�%��t����H��ٮ���3��Alv���Bdm�h-
.w�N�����AZ�g*%���H��P���8=��:�`2�3�2�S߷���wG�҄N7B�F��ӓåʏT�f��� /�Y�Y��恤����|�d�:Y��4��G�XCm��#���9�c_'������`O����d;�6t!+E����:����o;�o� M�V�~���o�t����:��礶��)|�E��=i�N�F�;2�n05"x� ��f��F���:���AW
6"����W�I�ȓ���"X��Lx�q�uka����=2̲0i� �L�<ǣ�K�%۩��}��d�������\��n�K��V��#��%���A�*�-<\�B<�����x���N���)�dW��C8v���v�vZ�������%c��(%fA�!x(�q�pP߳�,�M´��jc�{c�_�UC����h��#Umb��4c}F�ɦ�8���N��{E�6l�+��Եh��_��Rl"��5���/SBh��΢r���P]��J����Ͱȵ��.Cjg�D9jZ��<�P5Y��eV}W��b�X�8�P���0��V�4�+��&�V�J�(�$a+,�S�^G⑂���K�Wꬖ��Xl�j��El/�@Z��quE<�k�7v*D�˭�h�����M���{�}� ��xX�fn��ΐU'F����?��D<�C!����b��-V�t6� �X����W��ls�ߡEl� �m�I�~ew.�${)W���)�m��Tw���m*�P~L�Qi�E�R4������]N(ᨂک%��/&�1Z���w�y�7��d-t�f3�@6iK�����Y-�'��(�;~��T�D9�3�Eɗz?�r��_%�#��}U�8�q�ʷE����4�41z�oP��p��/����=c�Ҍ���AY�`uԟfXd-W�&��S�"8��)�9���x1�N��B5���2�������}��usy���3�,�ߩ7���t~���3$O�Y�^��ֳ\�|D՚�ǥw�X!�IP�b�z7�����[(R~�K{��F���k�� BD�$V�O�#�B�X(0�� 4vm�����*0W��9H%/��Z�8:�m\"~meQ]/Q[�����^��	��` 	g����p�[J${Z`(r��(4�I���`u�5:"8���c�!�f-�Pmm�v���Xi���2W���q�u�=r�NĺaJnx�0J[�/�FΧ�r�M��\����!r���kH��O�L+~�?d����o�x��Tפ���H�Sh���qVHU`��4D1�B��sc^U���xϫy�ph� qlo�,��^��А-���ղH�T>w��WT_6^�F�}kǓ�>����bV�B����������޷3T�g�벫��c���(�*�֍J�S,5�N����+���/Nφ�NMD	�6`��?��=�g ��1l�� �?��$jD+�?h-��6Gj�ӄmDI��"�޹c����uQ�\ϩ����6Cb)ｽ��ԑ����E�~����d��PN�_�O��2�s���Ǘl
�Ҽ���RH�d��������}��-lٺ�G���&j/ա��H��Z��I�pJ�b;1H�"�w.�l�{���`�`!|�ߓ���i��I
_�v~���4_��f+��/���J��Lc�P/�`ޔ�{ו��'��x��륕�M����Y�3�V+�^�Y��	n�^#�\�g�����s��/���c�q�\���M���h��YO��������-w?l~p���{��G�m2���V+�[|m���{�B��Hjpҹ@����w7AH����ݪ;��),������C+@���ܾ��V�Q��M�h��.�#�hV��g�Ⱦl >����l~���?��+h���3�������m������sW���?��e�D�Ke��)�BmOǞn���g`�V�zP�0���'�f燎��4]��t���H9ᒈW�ʨI֬����9����K�#6�����=�j�7#�i�ە�ۣ#�(�oS��`�oGS����&���5˯�+�0���K��-VM�#Q$������247�����

=d�=6E�<��}*8Y��J��-�
�b�F/�`���Q'<V�~��e��Ԅ�5d�f��@�R�ʋ�  �^� �m���х�bFn��-*��e$F.)"�q�� �\@����+�R�$A��P��@M+O^Ή�y4�8�r��m�%��B���u�����N��m�:k{�5�M���fn��%W[�*+���y(?'�B����fߑ�%3$�6U0�
��U�s�5�j��*x����v����\�vk�&7s�ީ�`~�Q� P#q_�id�P!�����B�x�=UY�y��3Σ�Q�����*&Ky�!�z�F���Ԛ�ǩ2��	)YS���6Z"�
&��m��t5����`'����j"���)l���}slG?[�����4`��	�M��TBe.{�,�u��g_���9'��^�R���(�+���7�:G���d�#U�e;�d�l�����@�������P!9Kj��cꘈ��`W����j\�ӞSx��b̖Ǒ'��3_ ���q^r/1^bst	���`wD�}�f��E¦1���k��5w4hM'�#�#`O�:4N�B��ڦ�Re���� �?}J�ҝ%רt�^�Y��Y����U�C_�Ĝ���a�e(�qw��>Lu��<��R�s�Z:��_֝�)j5��o� ��8��_�����F[��:�PCZ�����mZ/�K�XP� �=�����v�؛�[T5Dy+���2r*#9��3���i����S�ݯ�[vx���J:#�G6vVHɤ`�-.8'��P�gڈ���נ��[��Y62.H�r6֕���-���sVY�tO��G�⢦���q����<a�����?�W}���G�4}�p�d�����\�E�olp��+�gű�eu��WY42��Ti�j��2"a
���g0Ϭ�s���=�KM�UeI��T�}�!�T�zS_orZl�C7����"����[p���F>"�02�(5���(<�TH��y���G�ъ����������-���}���<st�j���m<��w��K�ϖ1�$���D��Xb�$���1o�+4m��;ipJ��Qp��4���8�@K>�D�Z�ܗ1xZ?&a/�>N��Ӯ���
VB��!C�ʌO���ʈFd��?0���O��_2N<�i��Vk���/�톒7��K�R%T� ���˟xG#����� ׉	����ʟK�� �ſ/��M��Pߵ�`�S�iuq{)���������0��I*T~�����v�h�L�p�#����pUǜw�����v�I.�v5%��3���4<"
K"c�zw���7"^~1F�׉_/ㅩ<��jt�t�>I���}H���h:8�ۦ*\y�<���g1Іq�[�l�Xyl%;��;4��mJ�O2[��<#���\ah��wkϕ��4Uľ�����R�BXaQ/����l��[�D _�ӑ��?��(F���k8�%]�]�3w�ei ٩1�?��ç,�Dx��&g����(�_Ŀ�g?����GY�*֩�5�s~��k݂$�ҐD�>Z�m�!�����ٿY\�b�+~3�y�P\�Lx��������O�J�D)������t����'�780��;�8�E3t��-n�b���O�]���SUk�Ǎ��n�E]�1�0��e�)����0�3�Ϻx�;w����V.""{��&?8a�F�׷��}*�I��P$�w�pw�jj���@��C�#^ �qZ
�G�d���i�j�!s��j���\��]�J~�lP@̣r�Fr�KwQC3�!5mdQA��:��� �&�����q���Fx�p`���a�
?��Q���W�����2>�,��O�C�t]dR%�:8��_.����T�mձ.c�é�8��W��S�]�Ȩ��w-#f>O�����EF!6|0�f�B!gP4E����X��h���c.x�S��Y���z�S��^ߗ2�#���j��';�
;�:�]n���6}�"� �vg-�;����u.�JkAJ>�=��c)a5�\�@�IbձN�s-���+��G�?���i`b�.J91<#K 1�����!.4�o���5����9y��ǲ�r<9�$��q4h.\u�+��{ޤ��.���w���w��,cS1J̨����X�x=�����G��ʩA9�'f?���P'sӯ���]L~δ&nmE��r¶��,�EUE����sqT ���fX8�zg[�~�	�@�m����?|�JW"��K�q��ِ�����U�������y��kEO?��t��r5�%(��Ͳ�	2���#�����>4�� ��5T�i��}|0� �-���|��
"�;�+����#U.�R�m��K����k�$��:��@�M"�#y��M��������k�UpO$6��Ȭ�/����֤�^�)�[B(�<�|N �A>��T��+���q.۳)^8F"qΒ�tgAä|�ԝѦ��g^)�~H���n�g���R�'8�_i����	cb�T�����֤FsrW�b-7� U�5ln��/?���v#B�Ց�ܚs#�E \��a5B/"�'	4��֋��v����x~��.z��ώD�.P"	���,�B��|fuK+	���S`<R&9�D��Y�Bb7U�i �x�����F~X�/�'y>!n���P����̔�G�z�)ӗ��>��N|�����BaܒȠ����\	��/h��7qg�j֞Ek�a@>�(R@p��ؽ��iT��e�G�8����ٝ>��Ѡ���E��n�א��v b�0���1�w����e��R=8A�T�����Od�~���(Y|O`L^c��̑�'�}(ŏE/f�?_�"]g`mK� �����ν!#��(��Gs^x���|�+������
H�&IQl'G�!�W���"Op�+a1���$��!i��q8^O��#�Baǐd���E�o��	�@.�v^Ի?h��h ����r��z��ٓ䓥�ᯃ����Z�>�x:&�T� �4�$���.����
���ryư*MX��^�~�<�B`:��AL���M�DP��s��5�%��Os���޶s��j4r�qҫ8ф���NGoP�yn�^�mRB
Un�H 2�5r�Dc�d��H�����N���g~�n�ok���n����Wg�<9RR��l���,�Z.�{����iD�D����\��3�$��]���5UҞmj5	=-���h�
���,���2)��!���'����i;��򮵆k{�F,����Tؤ11MG�5Ϡ)QA�����ndLX�X�'�
���3#. ':a?[k�و9E���h�$#'^���4&���`둒��}��C���K8��z.�/'i�Y�p嗲i�/3%�(�����WRM��hO�.�~��	��������ݬ=�G��B�Ⱥ�޼���i�^��kϤ�a�� P��n��    �K��Q�� �J�� {XO'��g�    YZ
#PAYLOAD_END
