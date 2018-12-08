# mini_projet_yara

## Comment installer ?

Cet outil nécessite git (`sudo apt update && sudo apt install git`)

```bash
git clone https://github.com/pawneeranger/mini_projet_yara.git
cd ./mini_projet_yara
chmod +x install.sh
./install.sh
```

## Utilisation
```bash
Usage: mini_projet_yara OPTION

-h,	--help		print this help message
-uy,	--update-yara	update the yara database
-uc,	--update-clam	update the clam-av database
-a,	--add FILE	add custom rule to database
-s,	--start		start the signature check tool
```
