#!/bin/sh
# Chorfa A. 
# ver. 0.1
# 15.06.2019


carte=$1
essid=$2
cle=$3

/bin/echo -e "\033[33mConnexion à "$essid" via la carte "$carte"...\033[0m"

/bin/echo -e "\033[34m[+]IWCONFIG...\033[0m"
iwconfig $carte essid $essid ;iwconfig $carte key $cle

#echo -e "\033[34m[+]DHCP...\033[0m"
#dhcpd $darte

#echo -e "\033[34m[+]Test de connectivite\033[0m"
#ping -n 1 www.google.com
