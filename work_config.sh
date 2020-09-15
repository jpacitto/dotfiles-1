#!/bin/bash
# this makes it so the focus won't switch to the new terminal we create below
gsettings set org.gnome.desktop.wm.preferences focus-new-windows 'strict'
# to connect to vpn, open some terminals. Note that we can't do this after the vpn because that process won't
# exit
gnome-terminal -- bash -c "read -n 1 -p \"Press any key to continue. . .\" && echo \"ssh dev2\" && ssh dev2.evr.stratus.com -l bliepert"
gnome-terminal -- bash -c "read -n 1 -p \"Press any key to continue. . .\" && echo \"ssh dev2\" && ssh dev2.evr.stratus.com -l bliepert"
read -s -p "Please enter your password, bliepert: " password
sudo openconnect vpn-na.stratus.com << EOF
Stratus
bliepert
$password
EOF
# change the focus setting back to the default
gsettings set org.gnome.desktop.wm.preferences focus-new-windows 'smart'

