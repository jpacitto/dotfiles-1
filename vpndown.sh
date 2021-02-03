#!/bin/bash

# ucivpndown
# from
# http://www.socsci.uci.edu/~jstern/uci_vpn_ubuntu/ubuntu-openconnect-uci-instructions.html

# where you want any output of status / errors to go
# (this should match same var in the ucivpnup script)
# (required)
OCLOG="/tmp/oclog.txt"

OPENVPNEXE='/usr/sbin/openvpn'
if [[ ! -f "${OPENVPNEXE}" ]]; then
  echo "ERROR: ${OPENVPNEXE} does not exist on your system. Please install."
  exit 1
fi

# ----------------------------------------------------------
# you should not have to change or edit anything below here
# ----------------------------------------------------------

# become root if not already
if [ $EUID != 0 ]; then
    sudo "$0"
    exit $?
fi

echo "`date`: Script ${0} starting." >> "${OCLOG}" 2>&1

# Shut down openconnect process if one (or more) exists

# find the pid(s) of any openconnect process(es)
pidofoc=`pidof openconnect`
# use those pids to kill them
if [ "$pidofoc" != "" ]; then
	echo "`date`: Stopping openconnect PID ${pidofoc}." >> "${OCLOG}" 2>&1
	kill -9 ${pidofoc} >> "${OCLOG}" 2>&1
else
	echo "`date`: No openconnect found. (That's okay.) Continuing." >> "${OCLOG}" 2>&1
fi

# Close down the tun1 openvpn tunnel
${OPENVPNEXE} --rmtun --dev tun1 &>> "${OCLOG}"

# finally, restore the /tmp/resolv.conf
if [[ -f /tmp/resolv.conf ]]; then
	cp /tmp/resolv.conf /etc
fi

# adding this to add the gateway route back because it gets removed for some reason?
echo "/sbin/route add -net 0.0.0.0 gw 10.0.2.2 enp0s3"
/sbin/route add -net 0.0.0.0 gw 10.0.2.2 enp0s3

echo "`date`: ${0} script ending successfully." >> "${OCLOG}" 2>&1

