#!/bin/bash
echo "hello world!"
echo -e "\033[47m  \033[0m \033[?25h"
A=0
B=(0.1 0.2 0.3 0.)
function f1(){
	echo $A
	echo $B
	read A
	echo $A
	echo $B
	f2
}

function f2(){
	echo "f2()=================="
	for((i=0; i<=2; i++)); do
		echo ${B[i]}
	done
	f3
}

function f3(){
	echo "f3()=================="
	if [ $A = "w" ]; then
		echo "可以用="
	fi
}

f1
