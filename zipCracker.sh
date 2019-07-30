#!/bin/bash

#fichier zip
source=$1 

zip2john $1 > ./$1.hash

john --format=zip ./$1.hash
