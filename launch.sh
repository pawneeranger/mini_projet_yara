#!/bin/bash
depot='./depot'
quarantaine='./quarantaine'
sains='./sains'

#vérification des arguments
case $1 in
	'--help' | '-h')
		echo "Usage: ./launch.sh OPTION"
		printf "\n-h,\t--help\t\tprint this help message"
		printf "\n-u,\t--update\tupdate the yara database"
		printf "\n-a,\t--add FILE\tadd custom rule to database"
		printf "\n-s,\t--start\t\tstart the signature check tool"
		echo ""
		;;
	'--update' | '-u')
		#mise à jour yara db
		cd yara_db
		sudo rm -r rules/ 2>/dev/null
		git clone https://github.com/Yara-Rules/rules.git
		cd ..
		cp ./yara_db/custom/* ./yara_db/rules
		cat ./yara_db/rules/index_custom.yar >> ./yara_db/rules/index.yar
		;;
	'--start' | '-s')
		#surveillance du dossier de dépot
		inotifywait -m $depot -e create -e moved_to |
		    while read path action file; do
			echo "The file '$file' appeared in directory '$path' via '$action'"
			result=$(yara ./yara_db/rules/index.yar $path$file 2>/dev/null)
			results=$(echo $result | grep -scve '^\s*$')
			if [ $results -eq 0 ]; then
				printf "\n\033[0;32m[i]\033[0m Fichier sain\n"
				mv $path$file $sains/$file
			else
				printf "\n\033[0;31m[!]\033[0m Fichier déplacé en quarantaine\n"
				echo $result
				mv $path$file $quarantaine/$file
			fi
		    done
		;;
	'--add' | '-a')
		#ajout d'un fichier de règle custom
		if [ -z $2 ]; then
			echo "Usage: ./launch.sh OPTION"
			printf "\n-a,\t--add FILE\tadd custom rule to database\n"
		else
			result=$(yara $2 ./launch.sh 2>&1 | grep -sce "")
			if [ $result -eq 0 ]; then
				#règle valide, on l'ajoute à la base
				while [ -z $rulename ] || [ $rulename = "index" ]; do
					read -p "Entrer un nom pour la nouvelle règle: " rulename
					echo $rulename
				done
				cp $2 ./yara_db/rules/$rulename.yar
				mv $2 ./yara_db/custom/$rulename.yar
				echo "include \"./$rulename.yar\"" >> ./yara_db/custom/index_custom.yar
				echo "include \"./$rulename.yar\"" >> ./yara_db/rules/index.yar
				cp ./yara_db/custom/* ./yara_db/rules
				cat ./yara_db/rules/index_custom.yar >> ./yara_db/rules/index.yar
			else
				#règle non valide
				echo "Erreur: Cette règle n'est pas compréhensible par yara"
			fi
		fi
		;;
	*)
		echo "Usage: ./launch.sh OPTION"
		echo "Try \`--help\` for more options"
		;;
esac
