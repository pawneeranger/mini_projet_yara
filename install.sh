#!/bin/bash

sudo apt update
sudo apt install yara inotify-tools
mkdir yara_db
mkdir depot
mkdir quarantaine
mkdir sains
chmod +x ./launch.sh
printf "\n\n\033[0;32mINSTALATION TERMINEE\033[0m\n"
printf "Pour lancer l'outil: "
printf "\n./launch.sh (depuis ce répertoire)\n"
cd ..
rm -rf install.sh
