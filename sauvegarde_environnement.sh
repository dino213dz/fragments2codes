#! /bin/bash

#Variables de mise en forme
FORMAT_TITRE='\033[31;4m# '
FORMAT_WARNING='\033[33;1m|--------(!)'
FORMAT_RESET='\033[0m\n'


#Variables du script
nom_machine=$(hostname)
DATE_BACKUP=$(date +'%d-%m-%Y_%Hh%Mm%Ss')
part_mount_test_sauvegarde=$(mount -l | grep 'volume1 on /mnt/data')
part_mount_test_vbox=$(mount -l | grep 'Temp on /mnt/Temp type vboxsf')
chemin_sauvegarde_locale='/mnt/data/backup'
chemin_sauvegarde_share='/mnt/Temp/'$nom_machine'/backup'
fichier_logs=$chemin_sauvegarde_share'/bck_'$DATE_BACKUP'/script_sauvegarde.log'

#echo $DATE_BACKUP
#Verification des points de montage/dossiers de sauvegarde
echo -en $FORMAT_TITRE'Verification des points de montage...'$FORMAT_RESET
if [ -d $chemin_sauvegarde_locale ] 
then 
echo -en $FORMAT_WARNING'Le Point de montage /mnt/data/existe: OK!'$FORMAT_RESET
else
mkdir $chemin_sauvegarde_locale
chmod ugo+wrx $chemin_sauvegarde_locale
fi

if [ -d $chemin_sauvegarde_share ]
then
echo -en $FORMAT_WARNING'Le Point de montage "/mnt/Temp" existe: OK!'$FORMAT_RESET
else
mkdir $chemin_sauvegarde_share
chmod ugo+wrx $chemin_sauvegarde_share
fi

#Monte la partition de sauvegarde
echo -en $FORMAT_TITRE'Montage de la partition de sauvegarde...'$FORMAT_RESET
if [ "$part_mount_test_sauvegarde" != "" ]
then
echo -en $FORMAT_WARNING'Le lecteur de sauvegarde est déjà monté sur "/mnt/data" !'$FORMAT_RESET
else
mount -t xfs /dev/VGWE/volume1 /mnt/data
echo -en $FORMAT_WARNING'Le lecteur sauvegarde a été monté sur "/mnt/data" !'$FORMAT_RESET
fi

#Monter le partage VBox
echo -en $FORMAT_TITRE'Montage de la partition de partage VBox...'$FORMAT_RESET
if [ "$part_mount_test_vbox" != "" ]
then
echo -en $FORMAT_WARNING'Le lecteur "VBox" est déjà monté sur "/mnt/Temp" !'$FORMAT_RESET
else
mount -t vboxsf Temp /mnt/Temp
echo -en $FORMAT_WARNING'Le lecteur "VBox" a été monté sur "/mnt/Temp" !'$FORMAT_RESET
fi

#Creation du dossier de sauvegarde:
echo -en $FORMAT_TITRE'Création des dossiers de sauvegarde journaliers locale et share...'$FORMAT_RESET
mkdir $chemin_sauvegarde_locale'/bck_'$DATE_BACKUP
mkdir $chemin_sauvegarde_share'/bck_'$DATE_BACKUP

#Sauvegarde du dossier root
echo -en $FORMAT_TITRE'Sauvegarde du dossie root dans :  '$chemin_sauvegarde_locale'/bck_'$DATE_BACKUP'/root.gz'$FORMAT_RESET
echo 'Dossier root:' >> $fichier_logs
zip -r $chemin_sauvegarde_locale/bck_$DATE_BACKUP/root.gz /root/ >> $fichier_logs

#Sauvegarde des scripts contenus dans etc/scripts (utilisés par crontab):
echo -en $FORMAT_TITRE'Sauvegarde des scripts contenus dans "/etc/scripts" dans : '$chemin_sauvegarde_locale'/bck_'$DATE_BACKUP'/etc_scripts.gz /etc/scripts/'$FORMAT_RESET
echo 'Scripts /etc/scripts :' >> $fichier_logs
zip -r $chemin_sauvegarde_locale/bck_$DATE_BACKUP/etc_scripts.gz /etc/scripts/ >> $fichier_logs

#Sauvegarde du crontab :
echo -en $FORMAT_TITRE'Sauvegarde du crontab "/etc/crontab" dans : '$chemin_sauvegarde_locale'/bck_'$DATE_BACKUP'/crontab.gz /etc/crontab'$FORMAT_RESET
echo 'crontab:' >> $fichier_logs
zip $chemin_sauvegarde_locale/bck_$DATE_BACKUP/crontab.gz /etc/crontab >> $fichier_logs

#copie des sauvegardes locales vers le share
echo 'Copie vers le share:' >> $fichier_logs
cp -r $chemin_sauvegarde_locale/bck_$DATE_BACKUP/* $chemin_sauvegarde_share/bck_$DATE_BACKUP/ >> $fichier_logs

grc du -h $chemin_sauvegarde_locale/bck_$DATE_BACKUP/
grc du -h $chemin_sauvegarde_share/bck_$DATE_BACKUP/
