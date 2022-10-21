#!/bin/sh

startvm()
{
	VBoxManage startvm rainfall --type headless 2> /dev/null
	for i in $(ls */* | grep flag | sort -V)
	do
		printf "%s: %s\n" $i $(cat $i)
	done
	printf "Key in user: "
	read reply
	ssh ${reply}@192.168.56.102 -p 4242
}

startcontainer()
{
	DOCKERFILE=$(cat << EOF
FROM i386/ubuntu:trusty
RUN apt-get update && apt-get install -y gcc python gdb g++ ltrace
RUN echo "set disassembly-flavor intel" > ~/.gdbinit
EOF
	)

	echo "$DOCKERFILE" | docker build -t rainfall-clone -
	docker run -ti -v $(pwd):/rainfall -w /rainfall rainfall-clone bash
}

if [ $# -eq 0 ]
then
	echo "usage: ./do.sh rainfall|clone"
	exit 1
fi

case $1 in
	rainfall)	startvm
				;;
	clone)		startcontainer;
				;;
	*)			echo "Bad argument.";
				exit
				;;
esac

