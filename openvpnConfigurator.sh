#!/bin/bash

titre='\033[1;33m [+]'
texte='\033[1;36m : '
reset='\033[0m'

dossierInstall=$1
dossierInstall='/sources/NordVPN'

fichierSource='nordvpn-release_1.0.0_all.deb'
fichierConfig='ovpn.zip'
fichierCle='nordvpn_public.asc'

urlSource="https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/$fichierSource"
urlConfig="https://downloads.nordcdn.com/configs/archives/servers/$fichierConfig"
urlCle="https://repo.nordvpn.com/gpg/$fichierConfig"


#creation du dossier source
echo -e $titre"Creation du dossier source$texte$dossierInstall"
mkdir $dossierInstall 2>/dev/null
cd $dossierInstall

#DL sources NordVPN
echo -e $titre"Téléchargement des fichiers source$texte$urlSource"
wget -qnc "$urlSource"

#Installation paquets
echo -e $titre"Installation des paquets$texte$dossierInstall/$fichierSource"
dpkg -i "$dossierInstall/$fichierSource"


#Update paquets et installation
echo -e $titre"APT Update et Install$texte NordVpn"
apt update
apt install nordvpn

#telechargement du certificat
#si erreur PUB_KEY) faire avant dl config
echo -e $titre"Téléchargement de la clé publique$texte$urlCle"
wget "$urlCle" -O - | sudo apt-key add

#Installation du certificat
echo -e $titre"Installation de la clé publique$texte ca-certificates"
apt install ca-certificates

#DL config
echo -e $titre"Téléchargement des fichiers de configuration NordVPN$texte$urlConfig"
cd /etc/NordVPN
wget "$urlConfig"
unzip $fichierConfig
rm $fichierConfig

cd $dossierInstall

#login
echo -e $titre"Login NordVPN$texte"
nordvpn login
echo -e $titre"Connexion NordVPN$texte"
nordvpn connect


#affichage de l'IP publique 
echo -en $titre"IP Publique$texte"
curl "https://ipinfo.io/ip"

echo -e $reset

