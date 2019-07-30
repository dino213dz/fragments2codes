#!/bin/bash
#
# Titre:		PingEtcHosts.sh
# Description:		Ping les ip de classe C contenue dans le fichier /etc/hosts
# Version:		1.0.0.3
# Date creation:	03.02.2019 22:00
# Derniere modif.:	03.02.2019 23:23
#
# Auteur:		CHORFA Alla-eddine
# E-Mail:		dino213dz@gmail.com

#options/parametres
parametreUnique=$1

#Parametres dispo:
# -h, --help	: 	affiche l'aide
# -a, --all	:	ping toutes les ip du fichier etc/host (classe A,B et C)

#parametrage des variables
c_rouge="\033[31m"
c_jaune="\033[33m"
c_vert="\033[32m"
c_reset="\033[0m"
c_gras="\033[1m"
c_souligne="\033[4m"
c_markeur="\033[7m"

total_ip=0
total_ip_off=0
total_ip_quiet=0

liste_ip_off=""
liste_ip_quiet=""

#Fonctions:
function formatterPingEnMessage () {
	ligne=$1
	filtreIP=$2 #filtre les ip du fichier host: classe A, B ou C

	#on récupere l'IP
        iplike=$(echo $ligne|cut -d ' ' -f 1|cut -c -13)
        #on recupere la partie reseau de l'IP
        reslike=$(echo $iplike|cut -c -8)	
	#si le reseau est de classe C:
        if [ "$reslike" = "$filtreIP" ];then
                total_ip=$(echo ""$total_ip"+1"|bc)
                #resultat du ping dans une variable
                pingres=$(ping -c 1 $iplike)
                #temps de reponse du ping
                t_ping=$(echo $pingres|cut -d ' ' -f 14|cut -d '=' -f 2)
                #packets perdus en %
                p_ping=$(echo $pingres|cut -d ' ' -f 26)
                #message à afficher
                message=$total_ip"- Ping $c_vert$iplike$c_reset : "$c_souligne$t_ping" ms"$c_reset" et "$c_souligne$p_ping$c_reset" packets perdus"
                #si on n'a pas le temps mais plutot le terme "packets": cas de non reponse aux pings
                if [ "$t_ping" = "packets" ];then
                        total_ip_quiet=$(echo $total_ip_quiet"+1"|bc)
                        liste_ip_quiet=$liste_ip_quiet" "$iplike" "
                        message=$total_ip"- Ping $c_vert$iplike$c_reset : "$c_markeur$c_jaune"Ne réponds pas aux pings!"$c_reset
                fi
                #si la machine est injoignable:
                if [ "$t_ping" = "---" ];then
                        total_ip_off=$(echo $total_ip_off"+1"|bc)
                        liste_ip_off=$liste_ip_off" "$iplike" "
                        message=$total_ip"- Ping $c_vert$iplike$c_reset : "$c_markeur$c_rouge"IP injoignable!]"$c_reset
                fi
                #afficher le message
                echo -e ""$message""
		#cas ou ce n'est pas une IP de meme classe que $filtreIP (classe C par defaut):
        #else
        #       echo -e $c_rouge"- On zappe "$reslike$c_reset
        fi	
}

#titre
echo -e $c_souligne$c_gras$c_jaune"Ping des ip de classe C conntenues dans le fichier /etc/hosts :"$c_reset"\n"

#parcours du fichier /etc/hosts:
while read ligne;do

	echo $(formatterPingEnMessage $ligne "192.168.")
	#Parametre --all
	if [ "$parametreUnique" = "--all" ] || [ "$parametreUnique" = "-a" ];then
		if [ "$reslike" = "172.[16,31]." ];then
			echo $(formatterPingEnMessage $ligne "192.[16-31].")
		fi
		if [ "$reslike" = "10." ];then
                        echo $(formatterPingEnMessage $ligne "10.")
                fi
	fi	
done < /etc/hosts

#totaux
echo -en "\n"$c_gras""$c_vert""$total_ip""$c_reset" ip pinguées"
if [ $total_ip_off -gt 0 ] || [ $total_ip_quiet -gt 0 ];then 
	echo -e ":"
fi
if [ $total_ip_off -gt 0 ];then
	echo -e "- "$c_rouge""$total_ip_off""$c_reset" injoignables:"$liste_ip_off
fi
if [ $total_ip_quiet -gt 0 ];then
	echo -e "- "$c_jaune""$total_ip_quiet""$c_reset" ne repond(ent) pas aux pings:"$liste_ip_quiet
fi


#on reset toutes mise en forme avant de quitter
echo -e $c_reset
