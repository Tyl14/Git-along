#!/usr/bin/bash

if [ $# -ne 2 ]; then
    echo "Ce programme demande deux arguments : 1 fichier d'entrée contenant des urls et 1 fichier sortie"
    exit
fi

Fichier_urls=$1
SORTIE=$2

while read -r line
do echo -e "${lineno}\t${line}";
	lineno=$(expr $lineno + 1)

# Si l'url est ok
if [[ $line =~ ^https?:// ]]
then
	echo "$line ressemble à une url"

# Vérifier l'encodage UTF-8
if curl -s "$line" | iconv -f UTF-8 -t UTF-8 >/dev/null 2>&1
then
	echo "$line URLS valide"
	echo -e "$ligne_id\t$line\t$(curl -s -o /dev/null -w "%{http_code}\t%{content_type}" "$line")\t$(curl -s "$line" | wc -w)" >> tableau-fr.tsv
	ligne_id=$((ligne_id+1))
	# Extraction du texte des pages
	lynx -dump -nolist "$line" >> contenu.txt

fi
fi

done < "$Fichier_urls";
echo "Tout est fait les bichties"
