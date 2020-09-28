#!/bin/bash
# this script is to allow i3 gap params to be changed

echo "i3: Setting inner gap to $1 and outer gap to $2"

cd ~/.config/i3
cp config config.bak #make our own backup 

sed -E "/gaps inner/s/[0-9]+/$1/" -i config --follow-symlinks
sed -E "/gaps outer/s/[0-9]+/$2/" -i config --follow-symlinks

i3-msg reload # reload i3 so the config takes effect
