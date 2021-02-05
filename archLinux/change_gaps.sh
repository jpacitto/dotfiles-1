#!/bin/bash
# this script is to allow i3 gap params to be changed
if [[ $# -gt 2 ]] || [[ $# -eq 0 ]]; then
	echo "Invalid number of arguments!"
	exit 1
fi

if [[ $# -eq 1 ]]; then # only one arg, it's a special one :)
	if [[ $1 = "work" ]]; then
		inner=0
		outer=0
	elif [[ $1 = "play" ]]; then
		inner=40
		outer=2
	else
		echo "If you want to use one argument, it must be 'work' or 'play'"
		exit 1
	fi
elif [[ $# -eq 2 ]]; then # default to using the first and second args
	inner=$1
	outer=$2
fi

echo "Creating backup config at ~/.config/i3/config.bak"
cd ~/.config/i3
cp config config.bak #make our own backup 

echo "i3: Setting inner gap to $inner and outer gap to $outer"

sed -E "/gaps inner/s/[0-9]+/$inner/" -i config --follow-symlinks
sed -E "/gaps outer/s/[0-9]+/$outer/" -i config --follow-symlinks

i3-msg reload # reload i3 so the config takes effect
