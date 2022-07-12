#!/bin/bash
 
declare -i x=5
declare -i y=5
declare -i len=4
 
declare -i x_arr=(1 2 3 4 5)
declare -i y_arr=(5 5 5 5 5)

declare -i res=0
 
dir='d'
level_arr=(0.3 0.2 0.1 0.01 0.005)

init() {
	clear
	echo -e "\033[0m"
	echo -e "\033[?25l"
	gen_food
}

set_show() {
		# \33[y;xH设置光标位置 
        for ((i = 1; i < $len; i++)); do
			echo -e "\033[47m\033[36m"
			echo -e "\033[${y_arr[$i]};${x_arr[$i]}H*\033[0m"
        done
		echo -e "\033[42m\033[37"
		echo -e "\033[${y_arr[$i]};${x_arr[$i]}H+\033[0m"
 
		echo -e "\033[${randomy};${randomx}H$\033[0m"
 
		for ((i = 0; i <= 60; i++)); do
			echo -e "\033[27;${i}H#\033[0m"
			echo -e "\033[0;${i}H#\033[0m"
		done
		
		for ((i = 0; i <= 27; i++)); do
			echo -e "\033[${i};0H#\033[0m"
			echo -e "\033[${i};60H#\033[0m"
		done
 
		echo -e "\033[16;65Hsnake:${x},${y}\033[0m"
		echo -e "\033[17;65Hfood :${randomx},${randomy}\033[0m"
		echo -e "\033[28;0H\033[43mscore:${res}\033[0m"
}

move() {
        case $dir in
			"w") y=$y-1 ;;
			"s") y=$y+1 ;;
			"a") x=$x-1 ;;
			*) x=$x+1 ;;
			"q") ret ;;
		esac
		# 吃到食物
		if [[ $x -eq $randomx && $y -eq $randomy ]]; then
			((len++))
			((res++));
			x_arr[$len]=$x
			y_arr[$len]=$y
			gen_food
			return
		fi
 
		if [[ $x -le 1 || $y -le 1 || $x -ge 60 || $y -ge 27 ]]; then
			echo "出范围"
			ret;
		fi
 
		for ((i = 2; i <= $len; i++)); do
                if [[ $x -eq ${x_arr[$i]} && $y -eq ${y_arr[$i]} ]]; then
					echo "吃到自己"
                	ret;
                fi
        done
 
        for ((i = 0; i <= $len; i++)); do
                x_arr[$i]=${x_arr[$i+1]}
                y_arr[$i]=${y_arr[$i+1]}
        done
		echo -e "\033[${y_arr[0]};${x_arr[0]}H\033[40m \033[0m"
        x_arr[$len]=$x
        y_arr[$len]=$y
}

gen_food() {
	let flag=1
	while [ $flag -eq 1 ]; do
		let randomx=$(($RANDOM%57+2))
		let randomy=$(($RANDOM%24+2))
		# 判断食物是否在蛇身
		for ((i=0;i<len;i++)); do
			if [[ ${x_arr[$i]} -eq $randomx && ${y_arr[$i]} -eq $randomy ]]; then
				break
			fi
		done
		if [ $i -eq $len ]; then
			flag=0
		fi
	done
}

ret() {
	echo -e "\033[0m"
	echo -e "\033[?25h"
	exit
}

init
set_show
while :; do
    olddir=$dir
	if [ $res -lt 5 ]; then
		level=0
	elif [ $res -lt 10 ]; then
		level=1
	elif [ $res -lt 15 ]; then
		level=2
	elif [ $res -lt 20 ]; then
		level=3
	elif [ $res -lt 25 ]; then
		level=4
	fi
    if ! read -n 1 -t ${level_arr[level]} -s dir; then
            dir=$olddir
    fi
	
	# 不能180反向
	if [[ $dir = "w" && $olddir = "s" ]]; then
				dir=$olddir
	fi
	if [[ $dir = "s" && $olddir = "w" ]]; then
				dir=$olddir
	fi
	if [[ $dir = "a" && $olddir = "d" ]]; then
				dir=$olddir
	fi
	if [[ $dir = "d" && $olddir = "a" ]]; then
				dir=$olddir
	fi
	
    move
    set_show
done
