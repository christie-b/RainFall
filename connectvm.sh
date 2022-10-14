#!/bin/sh

file=$(find -name flag -size +0 -printf "%T+\t%p\n" | sort -r | cut -f 2 | head -1)
password=$(cat $file)
VBoxManage startvm rainfall --type headless 2> /dev/null
printf "Password is $password\n"
ssh $(echo * | tr ' ' '\n' | grep lev | sort -nr | head -1)@192.168.56.102 -p 4242
