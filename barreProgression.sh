#!/bin/bash

function echox	{
	echo -e "$1"; sleep $delai;tput cuu1;tput el
	}

function afficherBarre {
	#entiers
	fb_fait=$1
	fb_total=$2
	taille_barre=$t____barre
	#texte
	fb_car_fait="■"
	fb_car_restant="■"
	fb_barre=''
	#couleurs
	fb_col_fait="\033[0m\033[1;42;32m"
	fb_col_restant="\033[0m\033[0;44;36m"
	fb_fnd_fait="\033[0m\033[1;41;30m"
	fb_fnd_restant="\033[0m\033[0;45;30m"
	fb_col_texte="\033[1;33m"
	#calcul: pourcentage fait : unites
	fb_pourcent_fait_pct=$(( ($fb_fait*100) / $fb_total ))
	fb_taille_barre_fait=$(( ($fb_pourcent_fait_pct*$taille_barre) / 100 ))
	#generation: barre de progression (à 100%)
	for x in $(seq 1 $taille_barre);do
		fb_barre=$fb_barre""$fb_car_fait""
	done


	#generation: textes
	txt_fait_sur_total="$fb_fait/$fb_total"	
	txt_fb_pourcent_fait_pct="$fb_pourcent_fait_pct%"
	texte="[$txt_fb_pourcent_fait_pct][$txt_fait_sur_total]"
	#calcul: taille et position du texte (milieu de la barre)
	taille_txt=${#texte}
	pos_txt=$(( ($taille_barre-$taille_txt)/2 ))
	#generation: parties de la barre avant et apres le texte
	fb_barre_A=${fb_barre:0:$pos_txt}
	fb_barre_B=${fb_barre_A//$fb_car_fait/$fb_car_restant}
	#generation: (avant barre)+(texte)+(apres barre)
	fb_barre_texte="$fb_barre_A$texte$fb_barre_B"
	#generation: barre, partie "pourcent accomplie" (partie "faite")
	barres_fait=${fb_barre_texte:0:$fb_taille_barre_fait}
	#generation: barre, partie "pourcent restant" (partie "restante")
	nb_barres_restantes=$(( $taille_barre-$fb_taille_barre_fait ))
	barres_restantes=${fb_barre_texte:$fb_taille_barre_fait:$nb_barres_restantes}
	barres_restantes=${barres_restantes//$fb_car_fait/$fb_car_restant}

	barre_progression=$fb_col_fait""$barres_fait""$fb_col_restant""$barres_restantes""
	
	#barre_progression=${barre_progression/"$texte"/"$fb_col_texte$texte"}
	
	barre_progression="$barre_progression\033[0m"
	
	echo -e $barre_progression
	}

if [ ${#1} -eq 0 ];then
	total=180
else
	total=$1
fi

if [ ${#2} -eq 0 ];then
	t____barre=160
else
	t____barre=$2
fi

if [ ${#3} -eq 0 ];then
	delai=0.1
else
	delai=$3
fi

for nobarre in $(seq 1 $total); do
		
	echox $(afficherBarre $nobarre $total)

done

