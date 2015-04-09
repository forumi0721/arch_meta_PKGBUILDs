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

if [ ! -e /etc/skel/.ssh ]; then

	install -dm700 /etc/skel/.ssh
	install -dm600 "${temp}/id_rsa" /etc/skel/.ssh/
	install -dm644 "${temp}/id_rsa.pub" /etc/skel/.ssh/
	install -dm644 "${temp}/authorized_keys" /etc/skel/.ssh/
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
			mkdir -p "${h}/.ssh"
			chown ${u}:${g} "${h}/.ssh"
			cp -a /etc/skel/.ssh/* "${h}/.ssh/"
			chown ${u}:${g} "${h}/.ssh/"*
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
�7zXZ  �ִF !   t/��w�%P] �}��JF���Ê!`��=ad�V�w�{��F8��G�zKԒᄂ�̊[��d2���و&��~5�}-�֗� �Y|9�e;�K�5���\�?�_��0�7ᥪ��[�?�Կw�WdM�J_��s�C�dk榔��t*��RO����b�mx� }���hDƪ:��.C�dԫ	%��,૗��� :Vqw4��ձ���������I5TTeў�]id��D���GrT�p�%���|��5H�m5��`�&��j�`��|`��$���Z�V4��~g6�1��~Uc=K�`״��.=�h���yo��4�{z�mo�R���gA���=es��Ĉ�+�q������|x|Z��� ���dƳuQad0�@q���÷��y]���2F��o�_�4b9Ç^7���HI#6V�k���lb�U�6P��ll�����1Q7C����vo�	g�Q'�.Z�]t�C�R�����V1e*쮆�JO�ԏxY�y�)8�t�hOi�2gDL�$�f!���2�V�����I�����H�01����4�G[C`�>�a\��=t}$��ز�.%�Og�'��8�����D&�>�o���FěE�XѪ|L|�2��Yp�B���W�8n���IR*E�s�{��Q[�s3���:;���~�`�c�:oi<��@��c�*;�V_h\�-�~��Ĵ�AߴTgP�"�1�L��,�!�B1�ɢ�,�g^Z&G]~	������#i?�q妦���\9���1?��L`�6��	"s��_�=��!�?���>�L�{4�X�&�X��o� ���m���T�4���� �_))�
��븛��?�c�%��{�1�)c�&jJu��SoF��Uc�ڊ����j�T�&����(Rkǔ�{Rq����F����z�K�܀Ə�a:N��
y�:LI>��)�y�غ
���������8�0T��k������F�/�}��X<��Nm��)tT�����z�d�b�����{�|C�S�2�׋�<��p����b|����_DPh����Z�a+��H��Aw��:�����N4���p=��ř�ɼ�Y?�Voߜ �s������� �v����,�b?V��(0����>]yD�EOgoH�lm���� NW���ۃ�쳽�[�\��uT�fSt�i2���Lf�z|M�96��Q2~��S���$L�ڽ���'%L8'_-v�X���<Õ���y�sq�\EzP��p�tv-�G &�Ɖ��K��>g�Q��u��\l�Y���1������Ƹ���X�T����n��a)O:��%#�C�k�wu	�**�0���X�#��+FT
�?6$L\c�B�ܨH��b}BY������}�/��r����ڣɨ��ĤA�@� h�
�����$��6g�7�`!Q�T�mu����\\�َ��N��ϗ�����ڀ���D�}��n$Pؤ���^�OJ���Ou��ф`�
�d}[�U��>���\8;����vSW˓j6����p����q!���n�K�?L�Vչ��n"��6���&�&�- ��s�ʬQ�dE��Ҳw	4���oG����|[$����,<��1�\\q%5B����'B��{(R�+߶`�@���	Vz�%9p�XB`�;����z���pQMEǾ">��{l����D5�#c0Ik)w�Ѹ�Q��{�����[�s�[�>����s��5���9Gx�#��Z�bf.�9tGJ)Y��bB����"mJſ&`�s\�_G4�6�m��wxuq�:�=��0	`�Wx*ad!�UK��\�M��-�͇�q�L���{���Y)(I�xe͊�7x�vy<�W\�Ǚs�IHW}���`�8��@��1̎�>9�����u��R/ʓVd*C�*�D�=E'�*(<�AT��	��lEH*<NpԖ7���� �E���յ��ɰ�q_��dȍ&a܋W7#�jL���������J�_$(��9���-Q�g��Kb�W�a����3��]k�e-E��F�֑u�y�
��l]�������I�!�k8P5�赉�U��r��|��_�T.�h�N[x�iZ�x{5�[8�K枭�3L*d��c/sq��ݮ�0.�d(���(�$��F9Cѯ�t
,$��g��@O����@�c��g��<�ӝ&�I�{'�>^����>�l������e��RPY�H����ǖO�{�!�m����%~"ڣ�$�aO����t�S����ߔwW��b�`��C#��)-�(m�pF�0�h�m�6�d28[�$d�o�n�G�	��r�dԐc��7��hk�Ӵ��F��k�8����ŵ�^�+�s�����Gx�$[�RE� |�^+�8��b����\�ͼ�	��-��E3ڡû�=�܋�g9p�X&M���vuf����I#�P�2�8O�H�M��6�ܪ��	�]~�3Y\ڛהSv���a�����J��ށr8��Ǧ���p���p�Qu��ѲƋ[�Q�A�ǟ$L������t�^/}��цv�Ҍ�G7w�>3N�o�;�Z������7��}.��Q���뭮�
����a�c���-S9�SO��YP%&����f��[ZG�.qh�� ]j�q'm�����Dؼ�O�5@�����p��v;�5�Ǝ��R:	 	����a�6w�ϊ������R�$�a*B�����n?j'�w,VohX�3ݟ���
����?;��6Xv�aK��d�1�0a��72=x	45�!���������HZ��i|��V�*}�[a|�����I�hź�N�������r: =���s �>��O��%���"�F�~9�
��;���	�H}�*��T�(�nL�y���N!��K=��i�Gۺ�G^i\����S�Տ@��*d��o�K>�Hq�y��;���]}�^a��u>���S�v�⽶!� �C��ғ޴�;a_�B�a��Ȥy�n��x�=���p�b�#���q�x��2#$��Q0@0'8dq}R#2�o#6}�q�v�eur�f1	@����mQ��c�)���vl����q��w�oF��}��@m����Nj���Ε��� �ӈ��3}�%i)?9�,�-&���U4IF�>>Z������|�=}S��g���)�!�S�G��#V\����B�<�G��.�e�ys���(����A��s.8F�zq�<�9���g�����7�WCC/s��]@�MRt�n,r��sT�����. Ɲ n����$�
��m�_����om�9�<$F?p�ԥ_�)T�^���Dha��V�Mꎾ�\�b�@����)]�F@�:�P;��%���-��i��@E�A]C
ζ�L�{]/C�'��B��bяXP(�c�U�peL��ۘ�\M�_��o���5`C�f[+�zh/c����[�PN+HZ�\'w}Pw��c�w/���Mr��ϙ�_����x��R�eȣ�\���E�c�nvPO�a�6A�`ё
njу	ݻ��ƴ�C��d���3���?A���1�u�.Ŭ���H
O�;��3����^���5C�2����C�n�!7���s&�\�=a���5 #/�Uy3K9@goDFq�v}a����|׻���o��Jo2[�:���o� wH��Y�ԽHi�o������e��M�@S����-;z�I�4+'�:h�C	u?���h�'�\�LW�2�EL7y���x4��~�(���H�^_Z�8Do� =͗�kY�Rw�<a�b��#Sǈ�����5�A�4!cJ�o�c�z@+��^�=ZϜ�+T�4��B�AGl��X��=�� �ꎦ��`����ݠ�VC�e=BB_oN����<qA�Dg�h�yކ�O"�h#�D�w�C��@F<a_�I!�[���~�{�rh^�-WkB�R0��(yI�q��:9�uG� ѓ$~�p�'+�5ļ��P���"��SQ����xS�o�j1%��B^���>H�o;���)h*l��� ~E�Hd��+��B�m�Y��t?����yiw�r�vT��_���s�H��8�&N91�kGB�]��jx���^��0P��>M��ߥPȽlᷣ�O٭�H���$X{S���p��t�L9�i�@ԑp)O��ء q�R^�$�\b��ma�{	@ϥ�:�1�����M���_}i�@I0��GT����GS���8m�,��EvYdý7���:	
������ aG`� �6�T�U%��,�w���[Y����o��� ���u�>��Ϩ��Y�ɣ����t�Y�mHԜ-�CY���m�����>Γ�������~��CAP����1i�R�>����U
O^L�Y�E�UӜ���1�2���11��3y@@ԗ"�B%P?�u������m�:m
g���nJ_�˿��z�RQ�M��Ȓ�;_S�i;�V�%��>P�Bp�`��K~����ę]��6�S���3Z
N�zІ��j���k�asj�6&6�64-�qVf�i�~��$�c�@��'��^ͦ��Ii%�	�*��A�(���0y�kc;@�̑E�*�V2�ʊ44�t||w ?�M`Y27�8K�����En��>�K�n�*"䧍l��֐˻E}؄j��Jݒ�	 [o���(��������7,��k�p�q253�n6إW{��i#��L�vN(�����n��'"Z�ە�����$�w
�f�z9W����5�sr�@�]Ky���p�]%q��AuA�K���z�9yd���zc����1��g�%z,8��O�$���i'= (G�IМW �@����ڕ�/X0��f���B,N���)�Ɍr0��Re��x�X
b_?���(}o;f%0�-�s��� ⼿v���WН3��ߠ�M���dj�r����`�`��̲�`�%��%u[�?}~��&��C���A��5�tlq�"�T#"?'��o$� � )��=j'/�ea\ ���/��U��P����}!Pq�O���Cٮ/X�UϚ�'eWң���t }�p����!�Bȣ�^�'=tE�t��]4s�s8؋!�s�O �.o���a"W�mBh^���.�v��l�]a��#`@���#�.U�pf+fU�x�L��`��]������В�Ngs����AqH��E6 ϳ_R�x $3������0x*7��ׄ?:Z�Z((�|�,jBP(Ʋ�D-���I���=l�Y�����ݱ�����Ѐ�gdv����D���B.�a�	F|24��Ov�g<�C���J�j� �B�+������ˠ�W�����X��RhU6�_4���
�A��Q
ێ�|�'�0ƺJ5!'V�OLh}^ 2�0��A ���l2}p�Ḡ	ש:D������RWK,&&$���A�&�_�X_=Wq�) )8�*\��t�`%�|ނ�i?�B��6m�Qu�!j�\\�w<ߚ�QWv���U����W��pxFV�t�)vO���	�Q&��
��WY��(OT-�@�N�#�Ÿ��ߤ~YZ�:�;��#?��@Ag�E��m]�K�=�>����:k��t�N� �uylJ�?�4��j�N�e�BPfRQ���:D&���+��R�li����j ��y��#����`���SB�f���OJ��]*ǧ�*�a䣘�q� ����!�Te�nY�E,�i`�b96@:F�3��*��4����.�j��wy�ލvU�sո�i��[ �d�s�U�2��qH�3Is6�3ļ����(����X����xm[�"�����>�s�4cI��̚�H��E��?�:������;��*�/���۵�S����I7�7�-�⒔���=t4��~ v�	1 ~����{����������g����c�C���(s�p�I���4N���_I4��؃��򃣉�����dG�%�(sO�^�zǕ���3���Fh��'�٪#��G���x��u�����P��/Ϣ���->�4�LrV�:*gV|��d�c%�M:���g+��1���H�P��M�Őd��d�4q#U�=x[B9�����GCD[M3�n�z���{�����ksr��ڤT<�|���d�� �5�5�����/;���T���|g�ۋ��V���"��dVZ�SwĵN�~��e�����{nӛ��d?0�6Q�| {͢�R�v��h�����5��/��9�ؒ\�T�� T����6�,���DFF_�t���}K�jS~m�"
Q�4x��2�E5��у�3��D�k��H�4,a�3��)�g)�T#��m�T�X7��UL�:H�����˦b��I���[�G:AV�*����-�ۍp#p�h�5�E����W�.��7:-�C�sx�Q=#�O��5���a-6A���<�i |�^��$�%�_����2���1e�fL����{��%���/P"���xWfR��.qH��)LHò̹�S�Q�|r�@������<
����P�[�+�ة�-����멫�WF���ϧ�,�*��~���:�����T��Й�C*=�Wj�6�o[��D2�cm��c�~5����b�s��=�i���/��I�ۛ��T�����z�׾�1}L�|#��X.�h`{��{��Dwt���b�vR=C�A,�k�����ͅ;&�ϱ��^ܶ0א~�PVa�+���t�h	�������Zy�Ax�]�3��%�Ͷ~t������ާ!e����;L����<|dz�/�$I�['f�%�Lu3�l�E�f�o��"�Y֝��tK�
��.�#�-e��,z|�F|G�ij��F��ԝ��G�_�77(@u&���5Y[�j�t�:z�ŭ��u]!�UMn�> �5H�s|�l�d�g��g�Ɗ� '_����t���D�z�����"2I��)o5Ǩ�\�Fb�V/���Cm
�����v���$�>4ɸ$Q�'���M!��iD�"� �2ef7L��񛘑���E�Q�t�zC���G7�^+uZxڂ8��������V���=�A�7J�9np��F֞�B^��
` af�ܗ-3��j������u3���C2�l5$�?����XXe�A��G=0��v6��C�?V��wh�*����L�������V�F~>pK��O8N�>��3&����WH�V��Jka��Ւ�&����MX��=*�c���'Nع�j�aB��A;�2����6���D�p�//�I�CD��� d�&Yj	�� 0�X%EsF�R��.o�hf"<�+g�݊��� �d�8n��zভm��T��Y�s,�Lg+�]������=��P�1�P�D�����1��p��m7��W�9 �м���.�TV+g�����P鳮�΢��jq�����K���A-�����: ��.�.�/<0$Wu�)WU�qcRLX~5kt8����Ð��tdD>c�����>�q*A�@�G)?'X��vo�w�AD� �\�}0��Iw��$��}%?@۟h	�2 ��)-�֪����{�r�Po\{k�Z��EedL��Q�d�C�@t1�=Ψ0E]Qp4�dH̲�R�V)�v��
�|yg�m`Z�U���U��$�Yj�A�u֢@KE_�B6�H��1/y�`T�G�����M���t�.��f���g�6n%��8�����O�M� �U�ҏ�$�K_�cџ+rp5g�򡓘`A�R����Aa@�[�Җ���I�L���[�Hg*g��)�Xkǟ[.�|M^�1	(뎧	��
-9�e� Y�J/C�i��-m52�1�;q�|�K}��/���#�+�*����%��ﰴ[FY��#��?%XLf��_u_C/@�A@��S��k�S/g^�r�xd����Q?+�iQ�����֠�&�"_a�N������~�!� �#�oc ~;��u�e����L��`,���0��X�n���-�a��`�s��Uy�~�pR�@��
�rHD�j����o�GP�@q��6p��;@o��P@��Z�=e2(�����i��z���u5��%U� �o7���Y^�u�J�/1h�t>	��~k��+'e�.��R4����ќ��O��'�����*C<��4���S�ui�z��&{[�����|r�c��B���″�C+���w*fX/���t�"Ŧ�,�[�C�M�1�~��Sܠ��S�2�(�\]�.�U�b���.n��>*:U
��^.A6��MT�łtC8���:&�W4i��G
L�?�Ǟ����V{s�q|½$-C�E��
��U��9Z�����kY+%uh��.�"���ҧ���eQ��mPu��\X�!щ���1�$�y�g)�M���Ys?�ɐ.��k�䡪�Pg%CF���,�>s��E	P�Qr�,������y�n���T�l3�3���!���F[L!�^��S�����E�'�r�9�-_��p P*B��ECgf��8� ?�C���2U@�*�� 8���hը��E�ͥ�sG9!06���9/Sp0k���}}մ�	8���:OI�s�o*'��1j��n"\U�&by��l�4�֒�!�悷�Y�\Ϝ�	��;�(s?}q���N��Gi���KK�j=Aݥ��PD!(��࢖�8Hd��0�}�V���37����Y���N�rY��
�F���ZA=o���T�����9a��Ay����T�$�l���e��PtU��9��~w�K+�]w�.���͸{G
�~=8:�`�;��d�{0Ũq3�e̾	{�6�t�?�w���X���"Iw�i6j	���f�oP��W��:��S�@�ߤ���p-a"-=4��k�P��K�2��p
�r�����&���1g������-e{)Vb�o>�Ƕ�(9��� �
���o���9_42Ս�����>Uw gM��ߟi$�Y��7�5�'�C	�0����%Y8����E������\,8X�F4w��w$6Y��:�+�_�|\��<1�#��?ĸ���͡ys����O�R{5\Gs!��lͦ��X������UBN��I��IhB��tU#��;�;D��aN�qxZl䞴�w�/!Fw�aS+}���yW���<�"#�:��~b�:��뒖p��J�V�%�_�?b)zx�����~y�q���F^���n;��0��H��I��*k�Y��?F}q�PR�m%�D�0�����-�3��x@������i4�Z�vz2�5Bn�TE�L[)���Tn����%a�s�=@Q���#��ȐDL<\�5�Ht�E�K�~ �@�I���p "l"���w�qfPm��W�U�-����!��Udw�tW�H��g!�x�1t�1��5n����RFn�yam���ͧ����y�r��=2��m���(�7�6�27������DLJ�z?�5EGPO�������W:}��� ?}:��?� �J�� f���g�    YZ
#PAYLOAD_END
