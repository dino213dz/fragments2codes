#!/bin/bash

function echox	{
	echo -e "$1"; sleep $delai;tput cuu1;tput el
	}

function afficherBarre {
	fb_fait=$1
	fb_total=$2
	fb_car_fait="|"
	fb_car_restant="|"
	fb_col_fait="\033[0m\033[1;41;33m"
	fb_col_restant="\033[0m\033[0;45;30m"
	fb_col_texte="\033[0m\033[1;33m"	
	fb_barre=''

	pourcentage=$(( ($fb_fait*100) / $fb_total ))

	for x in $(seq 1 $fb_total);do
		fb_barre=$fb_barre""$fb_car_fait""
	done

	#
	txt_fait_sur_total="$fb_fait/$fb_total"	
	txt_pourcentage="$pourcentage%"
	texte="$txt_pourcentage-$txt_fait_sur_total"
	taille_txt=${#texte}
	pos_txt=$(( ($fb_total-$taille_txt)/2 ))
	fb_barre_A=${fb_barre:0:$pos_txt}
	fb_barre_B==${fb_barre_A//$fb_car_fait/$fb_car_restant}
	fb_barre_texte="$fb_barre_A$texte$fb_barre_B"
	#
	barres_fait=${fb_barre_texte:0:$fb_fait}
	nb_barres_restantes=$(( $fb_total-$fb_fait ))
	barres_restantes=${fb_barre_texte:$fb_fait:$nb_barres_restantes}
	barres_restantes=${barres_restantes//$fb_car_fait/$fb_car_restant}

	barre_progression=$fb_col_fait""$barres_fait""$fb_col_restant""$barres_restantes"\033[0m"
	
	echo -e $barre_progression
	}

if [ ${#1} -eq 0 ];then
	taille=180
else
	taille=$1
fi

if [ ${#2} -eq 0 ];then
	delai=0.02
else
	delai=$2
fi

for nobarre in $(seq 1 $taille); do
	#barres_fait=${barre:0:$nobarre}
	#nb_barres_restantes=$(( $taille_barre-$nobarre ))
	#barres_restantes=${barre:0:$nb_barres_restantes}
	#barres_restantes=${barres_restantes//_/ }
	#pourcentage=$(( ($nobarre*100) / $taille_barre ))
	#echox "\033[1;42;33m"$barres_fait"\033[0m\033[1;32m"$barres_restantes" [$pourcentage%]"
		
	echox $(afficherBarre $nobarre $taille)

done

