#!/bin/bash

sudo apt update
sudo apt install yara inotify-tools clamav clamav-freshclam python3
sudo freshclam
sudo cp ./mini_projet_yara /usr/bin/mini_projet_yara
sudo chmod +x /usr/bin/mini_projet_yara
cd /var
sudo mkdir mini_projet_yara
sudo chown $USER ./mini_projet_yara/
cd mini_projet_yara
mkdir yara_db
cd yara_db
git clone https://github.com/Augustin-FL/clamav_to_yara3.git
git clone https://github.com/Yara-Rules/rules.git
mkdir custom
cd ..
mkdir depot
mkdir quarantaine
mkdir sains
echo "alias mini_projet_yara='bash /usr/bin/mini_projet_yara'" >> ~/.bashrc
. ~/.bashrc
echo "Installation is complete"
mini_projet_yara -h
