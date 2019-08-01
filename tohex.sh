#!/bin/sh
#CHORFA Alla-eddine
#V 1.0
#CHORFA 08.07.2019
alias echo='/bin/echo -e'

if [ "$1" = "" ]; then
	echo $aide
	exit
fi

if [ "$2" = "" ]; then
	echo $aide
	exit
fi

commande=$(echo $0|rev|cut -d "/" -f 1|rev)
aide="\033[32mAide:\nConverti les lignes hexa collées en paire d'hexa separés par expace afin de faciliter la conversion dans hex2raw\nIl ignore les lignes ommençant par \"#\"\n\n$commande [source] [destination] \n\nExemple : $commande ./ch21.txt.decoded.2.txt ./ch21.txt.decoded.and.converted.txt\n\n\033[0m"


source=$1
dest=$2
dec=0
nb_lignes=0
nb_lignes_hex_trouvees=0
max_char_extrait=100

echo "" > $dest

oldligne=$ligne="                           "
for ligne in $(cat $source); do 
	char1=${ligne:0:1}
	test1=${oldligne:0:9}  #Answers:
	test3=${olderligne:0:9} #Answers:
	test2=${oldligne:0:12} #[truncated]
	nb_lignes=$(echo "$nb_lignes+1"|bc)
	nb_chars=${#ligne}
	extraitligne=$ligne
	
	if [ $nb_chars -gt $max_char_extrait ]; then
		extraitligne=${extraitligne:0:$(echo "$max_char_extrait-3"|bc)}
		extraitligne="$extraitligne..."
	fi

	if [ "$char1" != "#" ];then
		echo -en "\n\033[33m["
		echo -en "\033[32m$nb_lignes"
		echo -e "\033[33m] LIGNE: $extraitligne"
		nb_lignes_hex_trouvees=$(echo "$nb_lignes_hex_trouvees+1"|bc)
		echo -en " |_["
		echo -en "\033[35m$nb_lignes_hex_trouvees"
		echo -en "\033[33m] HEX: "

		ligne=$(echo $ligne|sed "s/[ ]//g")
		ligne=$(echo $ligne|sed "s/[.]//g")
		ligne=$(echo $ligne|sed "s/[:]//g")
		ligne=$(echo $ligne|sed "s/[x]//g")
		ligne=$(echo $ligne|sed "s/[-]//g")
		lignehex=""
		
		nb_paire_chars=$(echo "$nb_chars/2"|bc)	


		for no in `seq 0 $nb_paire_chars`; do
			pos=$(echo "$no*2"|bc)
			char1=${ligne:$pos:1}
			paire=${ligne:$pos:2}
			lignehex="$lignehex$paire "
		done
		
		#debug
		echo -en "\033[35m$lignehex"
		if [  "$test1" = "#Answers:" ] || [ "$test3" = "#Answers:" ] ;then						
			echo "$lignehex" >> $dest
			echo -en "\033[31m [Answer"
			if [ "$test2" = "#[truncated]" ];then			
				echo -en "\033[31m truncated"
			fi
			echo -e "\033[31m]"
		else
			echo -e ""
		fi

		echo -en "\033[33m    |_[TXT] "
		h2r=$(echo $lignehex|hex2raw 2>/dev/null) 2>&1
		echo -e "\033[36m$h2r"
	fi
	olderligne=$oldligne
	oldligne=$ligne
done
#debug
echo "\033[31m$nb_lignes_hex_trouvees lignes converties\n"

echo "\033[35mConversion de totues les données récoltées avec hex2raw:"
echo "\033[36m"
cat $dest|hex2raw

echo "\033[0m"
