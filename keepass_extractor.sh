#!/bin/sh
alias echo="echo -e "
alias sed="/bin/sed"


source="/datas/neo_mdp/test.xml"
destination=$(pwd)"/test.wordlist.txt"

paire_login_mdp=""
nb_mdp=0

col_arbo='\033[33m'
col_user='\033[35m'
col_mdp='\033[31m'
col_resume='\033[36m'
col_reset='\033[0m'

while read ligne; do
	
	verif_si_password=$(echo $ligne_precedente|grep '<Key>Password</Key>')
	verif_si_username=$(echo $ligne_precedente|grep '<Key>UserName</Key>')

	mdp=$(echo $ligne|sed 's/<Value ProtectInMemory="True">//g'|sed 's/<\/Value>//g')
	login=$(echo $ligne|sed 's/<Value>//g'|sed 's/<\/Value>//g')

	if [ ${#verif_si_password} -gt 0 ]; then

		test_mdp=$(echo "$mdp"|egrep -i '<Value ProtectInMemory="True" />' )

		if [ ${#test_mdp} -gt 0 ];then
			mdp=""
		else 
			nb_mdp=$(echo "$nb_mdp+1"|bc)
		fi
		paire_login_mdp="$paire_login_mdp$mdp"

		echo "$col_arbo[$nb_mdp] MDP:$col_mdp$mdp$col_reset"
	fi

	if [ ${#verif_si_username} -gt 0 ]; then
		test_login=$(echo "$login"|egrep -i '<Value./>')

		if [ ${#test_login} -gt 0 ];then
			login=""
		fi

		paire_login_mdp="$paire_login_mdp $login\n"
		echo "$col_arbo |_[-] LOGIN:$col_user$login$col_reset\n"
	fi	

	ligne_precedente="$ligne"

done < $source

echo $paire_login_mdp >> $destination

clear

#echo $col_resume
#cat $destination
echo $col_reset
