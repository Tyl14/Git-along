#!/usr/bin/bash
if [ $# -ne 2 ]; then
    echo "Ce programme demande deux arguments : 1 fichier d'entrée contenant des urls et 1 fichier sortie"
    exit
fi

FICHIER_URLS=$1
SORTIE=$2

if [ ! -f "$FICHIER_URLS" ]; then
    echo "Ce programme demande un fichier"
    exit
fi

NB_LIGNE=0 # on aurait pu mettre lineno

cat > "$SORTIE" <<EOF
<!DOCTYPE html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@1.0.4/css/bulma.min.css"/>
</head>

<h1 class="title is-centered">Analyse des URLS </h1>
<table class="table is-bordered is-hoverable is-striped">
 <tbody>
    <tr>
        <th>Numero</th>
        <th>Adresse</th>
        <th>ReponseRequete</th>
        <th>Encodage</th>
        <th>NombreDeMots</th>
        <th>NombreDoccurencesduMotCible</th>
        <th>PagesHTMLBrut</th>
        <th>DumpTextuel</th>
        <th>Concordencier</th>
        <th>Contexte</th>

    </tr>
EOF

while read -r LINE ; do
    if [[ $LINE =~ ^https?:// ]]; then

        NB_LIGNE=$(expr $NB_LIGNE + 1)

        CODE_ET_ENCODAGE=$(curl -s -L -i -o "tmp.txt" -w "%{http_code}\n%{content_type}" "$LINE")

        CODE=$(echo "$CODE_ET_ENCODAGE" | head -n 1)

        if [ $CODE -eq 0 ]; then
            echo "<tr><td>$NB_LIGNE</td><td>$LINE</td><td>ERREUR</td><td>ERREUR</td><td>ERREUR</td></tr>" >> "$SORTIE"
            continue
        fi

        ENCODAGE=$(echo "$CODE_ET_ENCODAGE" | grep -E -o "charset=.*")

        if [[ "$ENCODAGE" =~ ('UTF-8'|'utf-8') ]]; then
            ENCODAGE_OU_PAS="UTF-8"
        else
            ENCODAGE_OU_PAS="NON"
        fi

        NB_MOTS=$(cat "tmp.txt" | lynx -dump -stdin -nolist | wc -w)

        NB_OCCURENCES=$(cat "tmp.txt" | grep "charge" | wc -w)

        PAGES_BRUT=$

        DUMP=$

        CONCORDENCIER=$

        echo "<tr><td>$NB_LIGNE</td><td>$LINE</td><td>$CODE</td><td>$ENCODAGE_OU_PAS</td><td>$NB_MOTS</td><td>$NB_OCCURENCES</td><td>$PAGES_BRUT</td><td>$DUMP</td><td>$CONCORDENCIER</td></tr>" >> "$SORTIE"

fi
done  < "$FICHIER_URLS"
cat >> "$SORTIE" <<EOF
</tbody>
</table>
EOF
