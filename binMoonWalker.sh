#!/bin/bash

alias echo='/bin/echo'

rouge='\033[1,31m'
jaune='\033[1,33m'
vert='\033[1,32m'
cyan='\033[1,36m'
reset='\033[0m'

fichier_source='./ch2.dmp'
exclustion='.*zlib.*|lzma'
fichier_logs='binwalk.log'
dossier_extract="./binwalk_extaract_"$(/bin/date +%s)"/"
indice=1
fichier_offset_prec=0

#Analyse et loggings
#echo -en $jaune"Analyse du binaire\nVeuillez patienter un moment svp... "
#binwalk -e -x "$exclustion" $fichier_source > $fichier_logs


#analyse des logs et extract des fichiers
mkdir $dossier_extract
echo -en $jaune"Extraction des fichiers\nVeuillez patienter svp... "
while read lig; do 

	fichier_offset=$(echo $lig|cut -d " " -f 1)

	fichier_type=$(echo $lig|cut -d " " -f 3-)
	fichier_type=$(echo $fichier_type|sed "s/Microsoft executable/EXE/g"|sed "s/Certificate in /CERT./g"|sed "s/Copyright string:/TXT/g")
	fichier_type=$(echo $fichier_type|cut -d " " -f 1)
	fichier_type=$(echo $fichier_type|sed "s/,//g")
	
	dec_count=0
	dec_offset=0
	count=$(($fichier_offset-$fichier_offset_prec+$dec_count))
	fichier_offset=$(($fichier_offset+$dec_offset))

	fichier_output=$fichier_type'_'$fichier_offset'.'$fichier_type
	
	echo -en "$jaune[$indice] bs=1 skip=$fichier_offset if=$fichier_source of=$dossier_extract$fichier_output count=$count\n$rouge"
	dd bs=1 skip=$fichier_offset if=$fichier_source of=$dossier_extract$fichier_output count=$count
	echo -e $cyan
	indice=$(($indice+1))

	fichier_offset_prec=$fichier_offset

done < $fichier_logs

echo -e $reset
