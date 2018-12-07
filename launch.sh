#!/bin/bash
depot='./depot'
quarantaine='./quarantaine'
sains='./sains'

#vérification des arguments
if [ $# -eq 1 ]; then
	if [ $1="--help" ] || [ $1="-h"]; then
		echo "Usage: ./launch.sh OPTION"
		printf "\n-h,\t--help\tprint this help message"
		printf "\n-u,\t--update\tupdate the yara database"
		printf "\n-a,\t--add\tadd custom rule to database"
		printf "\n-s,\t--start\tstart the signature check tool"
	elif [ $1="--update" ] || [ $1="-u"]; then
		#mise à jour yara db
		cd yara_db
		sudo rm -r rules/ 2>/dev/null
		git clone https://github.com/Yara-Rules/rules.git
		cd ..
	elif [ $1="--start" ] || [ $1="-s"]; then
		#surveillance du dossier de dépot
		inotifywait -m $depot -e create -e moved_to |
		    while read path action file; do
			echo "The file '$file' appeared in directory '$path' via '$action'"
			result=$(yara ./yara_db/rules/index.yar $path$file 2>/dev/null)
			results=$(echo $result | grep -scve '^\s*$')
			if [ $results -gt 0 ]; then
				printf "\n\031[0;32m[!]\033[0m Fichier déplacé en quarantaine\n"
				echo $result
				mv $path$file $quarantaine/$file
			else
				printf "\n\033[0;32m[i]\033[0m Fichier sain"
				mv $path$file $sains/$file
			fi
		    done
	elif [ $1="--add" ] || [ $1="-a"]; then
		echo "pas encore dispo"
	fi
else
	echo "Usage: ./launch.sh OPTION"
	echo "Try \`--help\` for more options"
fi
