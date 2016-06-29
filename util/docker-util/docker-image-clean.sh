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
	exit 1
}

image_list() {
	local images=`docker images | grep -e "^$1" | tr -s ' ' | cut -d' ' -f1,2 | tr ' ' ':'`
	return "${images}"
}

serializeid_img_ls() {
	local images=`image_list $1 | tr '\n' ' '`
	return "${images}"
}

target_image_show() {
	echo ------- Target Image -------
	echo `image_list $1`
	echo ----------------------------
}

while getopts hx OPT
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

if [ -z $FLAG_EX ]; then
	echo docker rmi `serializeid_img_ls ${PREFIX}`
else
	echo -n Above images will delete, is it OK? [y/n]
	read confirm
	if [ confirm = "y" ]; then
		echo docker rmi 'serializeid_img_ls ${PREFIX}`
	fi
fi

