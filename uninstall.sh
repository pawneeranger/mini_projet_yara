#!/bin/bash

sudo rm -rf /usr/bin/mini_projet_yara
sudo rm -rf /var/mini_projet_yara
unalias mini_projet_yara 2>/dev/null
sed '/alias mini_projet_yara/d' ~/.bashrc 1>/dev/null
. ~/.bashrc
echo "Successfully uninstalled"
echo "Consider removing the following packets : yara inotify-tools clamav clamav-freshclam python"
