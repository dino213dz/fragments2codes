#!/bin/sh
#hashcat -a 3 -m 500 ~/Downloads/cisco_hashes5_2.txt /usr/share/wordlists/dirb/big.txt --force
hashcat -a 3 -m 500 ~/Downloads/cisco_hashes5_2.txt ~/Downloads/10k-most-common.txt --force
#hashcat -a 3 -m 500 ~/Downloads/cisco_hashes5_2.txt ~/Downloads/10-million-password-list-top-1000000.txt --force

