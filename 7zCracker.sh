#!/bin/bash

#fichier 7z
source=$1 

/usr/share/john/7z2john.pl $1 > ./$1.hash

john --format=7z ./$1.hash
