#/bin/bash
if [ ${#1} -eq 0 ];then
	echo "Il faut passer un message 'commit' afin d'appliquer les changements et les uploader"
	exit
else
	commentaire="$1"
	git status
	git commit -am $commentaire
	git push origin master
fi
