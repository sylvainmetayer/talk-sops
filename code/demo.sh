#!/usr/bin/env bash

. ./demo-magic.sh -d -w

# To avoid interference with my existing key
unset SOPS_AGE_KEY_FILE
# Cleanup
rm age.key 02-demo.secrets.yaml
clear

################################
p "Création d'une clé age"
p "age-keygen > age.key"
test -f age.key || age-keygen > age.key 2>/dev/null
cat age.key

pubKey=$(grep 'key:' age.key | cut -d ':' -f 2 | xargs)

wait
################################
clear
p "Partons d'un fichier en clair"
pei "cat 02-demo.yaml" && echo

################################
p "Chiffrement du fichier avec $pubKey en destinataire"

pei "sops -e --age \"$pubKey\" 02-demo.yaml > 02-demo.secrets.yaml"
cat 02-demo.secrets.yaml

################################
p "Et maintenant, pour déchiffrer mes données ?"
clear
pe "sops -d 02-demo.secrets.yaml"
p "Oups, j'ai oublié de préciser ma clé privée"
pei "export SOPS_AGE_KEY_FILE=$(pwd)/age.key"
pe "sops -d 02-demo.secrets.yaml"

p "Et pour mettre à jour les données d'un fichier existant ?"
pe "sops 02-demo.secrets.yaml"
pei "cat 02-demo.secrets.yaml"

clear
p "Mais je n'aime pas vim moi !"
pe "EDITOR=\"code --wait\" sops 02-demo.secrets.yaml"
pei "cat 02-demo.secrets.yaml"

cd recipients && ./demo.sh