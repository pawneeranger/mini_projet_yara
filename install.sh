#!/bin/bash

sudo apt update
sudo apt install yara inotify-tools
mkdir yara_db
mkdir depot
mkdir quarantaine
mkdir sains
chmod +x ./launch.sh
printf "\n\n\033[0;32mINSTALATION TERMINEE\033[0m\n"
printf "\n...Téléchargement de la base de données Yara..."
./launch.sh -u
printf "\n\n\033[0;32mTéléchargement terminé\033[0m\n"
printf "Pour lancer l'outil: "
printf "\n\t./launch.sh (depuis ce répertoire)\n"
rm -rf install.sh
