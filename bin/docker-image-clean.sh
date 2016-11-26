#!/usr/bin/bash

#
# 2016-06-22
# Author: Mizuki Urushida
#

CMDNAME=`basename $0`

op_err_exit() {
	echo "${CMDNAME}: operand error" 1>&2
	echo "Try '${CMDNAME} -h' for more information." 1>&2
	exit 1
}

usage_exit() {
	echo "Usage: ${CMDNAME} [-x] PREFIX" 1>&2
	echo "Print command which deletes docker images you designate." 1>&2
	echo "" 1>&2
	echo "[Options]" 1>&2
	echo "-x:	Execute delete command" 1>&2
	exit 1
}

serialized_img_ls() {
	local images=`docker images | grep -e "^$1" | tr -s ' ' | cut -d' ' -f1,2 | tr ' ' ':' | grep -v "REPOSITORY:TAG" | tr '\n' ' ' | perl -pe 's|^(.*)\s$|$1|'`
	# TODO: The last perl one liner is really slow.
	echo "${images}"
}

image_list() {
	local images=`serialized_img_ls $1`
	echo ${images} | tr ' ' '\n'
}

target_image_show() {
	echo ------- Target Image -------
	image_list $1
	echo ----------------------------
}

while getopts :hx OPT
do
	case ${OPT} in
		h)	# HELP
			usage_exit
			;;
		x)	# execute delete command
			FLAG_EX=0
			;;
		\?)	op_err_exit
			;;
	esac
done
shift $((OPTIND - 1))

PREFIX=$1
target_image_show ${PREFIX}

SERIALIZED_IMG=`serialized_img_ls ${PREFIX}`

if [ -z $FLAG_EX ]; then
	echo docker rmi ${SERIALIZED_IMG}
else
	echo -n "Above images will delete, is it OK? [y/n]: "
	read confirm1
	if [ ${confirm1} = "y" ]; then
		echo -n "Are you sure? [y/n]: "
		read confirm2
		if [ ${confirm2} = "y" ]; then
			echo "Deleting images..."
			docker rmi ${SERIALIZED_IMG}
			echo "Complete!"
		fi
	fi
fi
