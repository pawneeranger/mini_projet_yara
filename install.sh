#!/bin/bash

sudo apt update
sudo apt install yara clamav git
mkdir yara_db
cd yara_db
git clone https://github.com/Yara-Rules/rules.git
printf "\n\n\033[0;32mINSTALATION TERMINEE\033[0m\n"
printf "Pour lancer l'outil: "
printf "\npython launch.py\n"
