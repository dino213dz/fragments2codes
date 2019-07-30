#!/bin/bash
PATH='/bin:/sbin:/usr/bin'
export PATH

rouge='\033[31m'
vert='\033[32m'
jaune='\033[33m'
bleu='\033[34m'
magenta='\033[35m'
cyan='\033[36m'
blanc='\033[37m'
reset='\033[0m'
separateur_infos="\n...___...___...___...___...___...___...___...___...___...___...___...___...___...___...___...___...___...___...___"

liste_separateurs=".,-,_"
liste_domaines="hotmail.fr,hotmail.com,outlook.fr,outlook.com,hotmail.com,gmail.com,gmail.fr,msn.com,msn.fr,facebook.com,facebook.fr,yahoo.fr,yahoo.com"
liste_domaines=$liste_domaines",laposte.net,wanadoo.fr,wanadoo.com,sfr.fr,red.fr,red.com,free.fr,aol.fr,orange.fr,orange.com,sosh.com,sosh.fr,bouygues.com,bbtel.com"
#liste_domaines=$liste_domaines",neocles.com,neocles.fr"


destination=$1

echo "on va generer des logins a partir d'un nom, prenom et d'un code postal ou departement"

echo -e $jaune
echo -e "$separateur_infos"

echo -en "Tapez un nom : "
read nom

echo -en "Tapez le prénom : "
read prenom

echo -en "Tapez un numero de departement ou un code postal : "
read dep_cp

if [ ${#destination} -eq 0 ];then
	echo -en "Tapez un chemin de destination : "
	read destination
fi


i_nom=${nom:0:1}
i_prenom=${prenom:0:1}

nbc_dep_cp=${#dep_cp}

#si code dep ou cp défini
if [ $nbc_dep_cp -gt 0 ];then
	#CP si 4 ou 5 caracteres
	if [ $nbc_dep_cp -eq 4 ] || [ $nbc_dep_cp -eq 5 ]; then
		dep=${dep_cp:0:2}
		cp=$dep_cp
	else
	#Departement : si 1, 2 ou 3 caracteres (dom-toms)
		dep=${dep_cp:0:2}
		if [ $nbc_dep_cp -eq 2 ]; then
			cp=$dep_cp"000"
		else
			if [ $nbc_dep_cp -eq 1 ]; then
				cp=$dep_cp"0000"
			else
				cp=$dep_cp"00"
			fi
		fi
	fi
fi

echo -e "$separateur_infos"
echo -e $magenta
echo -e "\nRésumé:\n\nNom:$nom\nPrenom=$prenom\nInitiales:$i_nom.$i_prenom.\n\nDepartement:$dep\nCP:$cp\n\nFichier destination: $destination\n\n"

#go
total=0
nb_domaines=0
liste=''
for domaine in $(echo $liste_domaines|sed "s/,/ /g"); do
	echo -e $magenta
	echo -e "$separateur_infos"
	echo -e "Domaine : $domaine\n"
	nb_domaines=$(echo "$nb_domaines+1"|bc)
	#combi cp dep
	echo -en $rouge
	if [ ${#cp} -gt 0 ];then
		echo -e "$nom$cp@$domaine"
		echo -e "$prenom$cp@$domaine"
		liste=$liste"$nom$cp@$domaine\n"
		liste=$liste"$prenom$cp@$domaine\n"
		total=$(echo "$total+2"|bc)
	fi
	if [ ${#dep} -gt 0 ];then
		echo -e "$nom$dep@$domaine"
		echo -e "$prenom$dep@$domaine"
		liste=$liste"$nom$dep@$domaine\n"
		liste=$liste"$prenom$dep@$domaine\n"
		total=$(echo "$total+2"|bc)
	fi	
	#collés
	echo -en $jaune
	echo -e "$nom$prenom@$domaine"
	echo -e "$prenom$nom@$domaine"
	liste=$liste"$nom$prenom@$domaine\n"
	liste=$liste"$prenom$nom@$domaine\n"
	total=$(echo "$total+2"|bc)
	if [ ${#cp} -gt 0 ];then
		echo -e "$nom$prenom$cp@$domaine"
		echo -e "$prenom$nom$cp@$domaine"
		liste=$liste"$nom$prenom$cp@$domaine\n"
		liste=$liste"$prenom$nom$cp@$domaine\n"
		total=$(echo "$total+2"|bc)
	fi
	if [ ${#dep} -gt 0 ];then
		echo -e "$nom$prenom$dep@$domaine"
		echo -e "$prenom$nom$dep@$domaine"
		liste=$liste"$nom$prenom$dep@$domaine\n"
		liste=$liste"$prenom$nom$dep@$domaine\n"
		total=$(echo "$total+2"|bc)
	fi
	#initiale nom puis prenom, et inversement
	echo -en $vert
	echo -e "$i_nom$prenom@$domaine"
	echo -e "$i_prenom$nom@$domaine"
	liste=$liste"$i_nom$prenom@$domaine\n"
	liste=$liste"$i_prenom$nom@$domaine\n"
	total=$(echo "$total+2"|bc)
	if [ ${#cp} -gt 0 ];then	
		echo -e "$i_nom$prenom$cp@$domaine"
		echo -e "$i_prenom$nom$cp@$domaine"
		liste=$liste"$i_nom$prenom$cp@$domaine\n"
		liste=$liste"$i_prenom$nom$cp@$domaine\n"
		total=$(echo "$total+2"|bc)
	fi
	if [ ${#dep} -gt 0 ];then
		echo -e "$i_nom$prenom$dep@$domaine"
		echo -e "$i_prenom$nom$dep@$domaine"
		liste=$liste"$i_nom$prenom$dep@$domaine\n"
		liste=$liste"$i_prenom$nom$dep@$domaine\n"
		total=$(echo "$total+2"|bc)
	fi
	#avec separateur
	for sep in $(echo $liste_separateurs|sed "s/,/ /g"); do
		echo -en $cyan
		echo -e "$nom$sep$prenom@$domaine"
		echo -e "$prenom$sep$nom@$domaine"
		liste=$liste"$nom$sep$prenom@$domaine\n"
		liste=$liste"$prenom$sep$nom@$domaine\n"
		total=$(echo "$total+2"|bc)
		if [ ${#cp} -gt 0 ];then
			echo -e "$nom$sep$prenom$sep$cp@$domaine"
			echo -e "$prenom$sep$nom$sep$cp@$domaine"
			liste=$liste"$nom$sep$prenom$sep$cp@$domaine\n"
			liste=$liste"$prenom$sep$nom$sep$cp@$domaine\n"
			total=$(echo "$total+2"|bc)
		fi
		if [ ${#dep} -gt 0 ];then
			echo -e "$nom$sep$prenom$sep$dep@$domaine"
			echo -e "$prenom$sep$nom$sep$dep@$domaine"
			liste=$liste"$nom$sep$prenom$sep$dep@$domaine\n"
			liste=$liste"$prenom$sep$nom$sep$dep@$domaine\n"
			total=$(echo "$total+2"|bc)
		fi
		#initiale nom puis prenom, et inversement
		echo -en $bleu
		echo -e "$i_nom$sep$prenom@$domaine"
		echo -e "$i_prenom$sep$nom@$domaine"
		liste=$liste"$i_nom$sep$prenom@$domaine\n"
		liste=$liste"$i_prenom$sep$nom@$domaine\n"
		total=$(echo "$total+2"|bc)
		if [ ${#cp} -gt 0 ];then
			echo -e "$i_nom$sep$prenom$sep$cp@$domaine"
			echo -e "$i_prenom$sep$nom$sep$cp@$domaine"
			liste=$liste"$i_nom$sep$prenom$sep$cp@$domaine\n"
			liste=$liste"$i_prenom$sep$nom$sep$cp@$domaine\n"
			total=$(echo "$total+2"|bc)
		fi
		if [ ${#dep} -gt 0 ];then
			echo -e "$i_nom$sep$prenom$sep$dep@$domaine"
			echo -e "$i_prenom$sep$nom$sep$dep@$domaine"
			liste=$liste"$i_nom$sep$prenom$sep$dep@$domaine\n"
			liste=$liste"$i_prenom$sep$nom$sep$dep@$domaine\n"
			total=$(echo "$total+2"|bc)
		fi		
	done
done
echo -e "$separateur_infos"
echo -e $rouge
echo -e "Total: $total"
echo -e "NB Domaines: $nb_domaines"
echo -e "$separateur_infos"
echo -e $vert"Export vers : $destination"
echo -e "$liste" > "$destination"
echo -e "$separateur_infos"

for i in $(seq 1 3); do 
	echo -ne '\007'
	sleep "0.$i"
done

echo -e $reset

