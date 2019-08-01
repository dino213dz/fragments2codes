#!/bin/bash

function echox	{
	echo -e "$1"; sleep $delai;tput cuu1;tput el
	}

function afficherBarre {
	fb_fait=$1
	fb_total=$2
	fb_car_fait="|"
	fb_car_restant="¤"
	
	fb_barre=''
	for x in $(seq 1 $fb_total);do
		fb_barre=$fb_barre""$fb_car_fait""
	done

	barres_fait=${fb_barre:0:$fb_fait}
	nb_barres_restantes=$(( $fb_total-$fb_fait ))
	barres_restantes=${fb_barre:0:$nb_barres_restantes}
	barres_restantes=${barres_restantes//$fb_car_fait/$fb_car_restant}
	pourcentage=$(( ($fb_fait*100) / $fb_total ))
	barre_progression="\033[1;42;33m"$barres_fait"\033[0m\033[1;32m"$barres_restantes"[$pourcentage%]"
	
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

