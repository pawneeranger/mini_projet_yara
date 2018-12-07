#!/bin/bash
depot='./depot'
quarantaine='./quarantaine'
sains='./sains'

#vérification des arguments
case $1 in
	'--help' | '-h')
		echo "Usage: ./launch.sh OPTION"
		printf "\n-h,\t--help\tprint this help message"
		printf "\n-u,\t--update\tupdate the yara database"
		printf "\n-a,\t--add\tadd custom rule to database"
		printf "\n-s,\t--start\tstart the signature check tool"
		echo ""
		;;
	'--update' | '-u')
		#mise à jour yara db
		cd yara_db
		sudo rm -r rules/ 2>/dev/null
		git clone https://github.com/Yara-Rules/rules.git
		cd ..
		;;
	'--start' | '-s')
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
		;;
	'--add' | '-a')
		echo "pas encore dispo"
		;;
	*)
		echo "Usage: ./launch.sh OPTION"
		echo "Try \`--help\` for more options"
		;;
esac
