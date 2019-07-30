#/bin/sh

iface=$1

iwconfig
ifconfig $1 down
iw reg set BZ
iwconfig $1 txpower 30
ifconfig $1 up
