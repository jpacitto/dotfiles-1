#!/bin/bash

# ucivpnup
#
# from
# http://www.socsci.uci.edu/~jstern/uci_vpn_ubuntu/ubuntu-openconnect-uci-instructions.html

# Edit the following down to the <<<END-EDIT>>> lines

# EXECUTABLE LOCATIONS
OPENVPNEXE='/usr/sbin/openvpn'
OPENCONNECTEXE='/usr/sbin/openconnect'
IPEXE='/bin/ip'
if [[ ! -f "${OPENVPNEXE}" ]]; then
  echo "ERROR: ${OPENVPNEXE} does not exist on your system. Please install."
  exit 1
fi
if [[ ! -f "${OPENCONNECTEXE}" ]]; then
  echo "ERROR: ${OPENCONNECTEXE} does not exist on your system. Please install."
  exit 1
fi
if [[ ! -f "${IPEXE}" ]]; then
  echo "ERROR: ${IPEXE} does not exist on your system. Please install."
  exit 1
fi


# VPNUSER
# (required)
VPNUSER='bliepert'

# VPNGRP
# (required)
VPNGRP="Stratus"

# your VPN password. At UCI we use our UCINetID password.  Storing it
# in plain text here in this file is insecure, though. It is better to
# put your password into a $HOME/.authinfo file and use a 2nd script
# to read that password and echo it.  If I find the time, I will add
# that functionality to this script and the instructions. At least
# this will suffice for now, 'just to get things going'.
#
# On the other hand, if you leave PW blank, or empty string, the
# script will prompt you for it.
# (optional)
#PW=""
PW=""

# where you want any output of status / errors to go
# (this should match same var in the ucivpndown script)
# (required)
OCLOG="/tmp/oclog.txt"

# where you will be connecting to for your VPN services
# (required)
VPNURL="vpn-na.stratus.com"

# (required)
# These are just guesses. If neither of these work on your
# system, you'll need to find where this is
if [[ -f "/usr/share/vpnc-scripts/vpnc-script" ]]; then
	VPNSCRIPT="/usr/share/vpnc-scripts/vpnc-script"
elif [[ -f "/etc/vpnc/vpnc-script" ]]; then
	VPNSCRIPT='/etc/vpnc/vpnc-script'
else
  echo "ERROR: I cannot find a 'vpnc-script' on your system. Please install via your distro's particular package manager."
  exit 1

fi	

# --<<<END-EDIT>>>--------------------------------------------------------
# (you should not have to change or edit anything below here)
# --<<<END-EDIT>>>--------------------------------------------------------

# become root if not already
if [ $EUID != 0 ]; then
    sudo "$0"
    exit $?
fi

# timestamp, visual break
echo "===================================================================" >> "${OCLOG}" 2>&1
echo "`date`: Script ${0} starting." >> "${OCLOG}" 2>&1

# first job: make a copy of /etc/resolv.conf since this file gets
# replaced by vpnc-script and needs to be restored by ucivpndown
# when vpn is shut back down
cp /etc/resolv.conf /tmp/resolv.conf.tmp

# Make an openvpn tunnel (interface), and if successful, use it to
# connect to our Cisco server. Script will hold with connection
# running until you hit Ctrl-C from the keyboard.
numtuns=`${IPEXE} link show tun1 2> /dev/null | wc -l`
if [ "${numtuns}" -eq 0 ]; then
	echo "`date`: Creating tun1 openvpn interface." >> "${OCLOG}" 2>&1
	${OPENVPNEXE} --mktun --dev tun1 >> "${OCLOG}" 2>&1
	# check successful, else quit
	if [ $? -eq 0 ]; then
		echo "`date`: tun1 openvpn interface created successfully." >> "${OCLOG}" 2>&1
		# we only want to copy over the temporary conf file if we were successful in
		# connecting.  (If we copied over when we were *not* successful, we would end up
		# (in the ucivpndown script) copying the wrong resolv.conf back to /etc/!)
		cp /tmp/resolv.conf.tmp /tmp/resolv.conf
	else
		echo "`date`: Problems creating tun1 openvpn interface. Exiting 1." >> "${OCLOG}" 2>&1
		exit 1
	fi
else
	echo "`date`: tun1 openvpn interface already exists. Exiting." >> "${OCLOG}" 2>&1
	exit 0
fi

# Turn on tun1 openvpn interface. If it is already on, it won't hurt
# anything.
echo "`date`: Turning tun1 on." >> "${OCLOG}" 2>&1
ifconfig tun1 up >> "${OCLOG}" 2>&1
#${IPEXE} link set tun1 up "${OCLOG}" 2>&1
# check successful, else quit
if [ $? -eq 0 ]; then
	echo "`date`: tun1 on." >> "${OCLOG}" 2>&1
else
	echo "`date`: Problems turning tun1 on. (This may leave tun1 existing though.) Exiting 1." >> "${OCLOG}" 2>&1
	exit 1
fi

# Check for any pre-existing openconnect connections. If one exists
# already, we will not create a new one.
pidofoc=`pidof openconnect`
echo "`date`: Running openconnect." >> "${OCLOG}" 2>&1
if [ "$pidofoc" == "" ]; then
	# echo "Please enter your password: "
	if [ -z "$PW" ]; then
		# True if $PW is empty
		${OPENCONNECTEXE} -b -s "${VPNSCRIPT}" \
						--user="${VPNUSER}" \
						--authgroup="${VPNGRP}" \
						--interface="tun1" \
						"${VPNURL}" >> "${OCLOG}" 2>&1
	else
		# Otherwise, we're sending the plaintext password to the script
		echo "${PW}" | ${OPENCONNECTEXE} -b -s "${VPNSCRIPT}" \
							--user="${VPNUSER}" \
							--passwd-on-stdin \
							--authgroup="${VPNGRP}" \
							--interface="tun1" \
							"${VPNURL}" >> "${OCLOG}" 2>&1
	fi
else
	echo "`date`: Not initiating an openconnect session because one appears to already exist: PID=${pidofoc}" >> "${OCLOG}" 2>&1
fi

# give a chance for stuff to click into place..
sleep 3

# if you want, you can optionally show the new IP info to the user
ip address show tun1

# and log same info
ip address show tun1 &>> "${OCLOG}"

# end script
echo "`date`: ${0} script ending successfully." >> "${OCLOG}" 2>&1

