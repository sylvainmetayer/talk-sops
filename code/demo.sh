#!/usr/bin/env bash

# To avoid interference with my existing key
unset SOPS_AGE_KEY_FILE

env | grep SOPS

################################
echo "Création d'une clé age"

# TODO if age.key, skip, or else, generate key
cat age.key

pubKey=$(grep 'key:' age.key | cut -d ':' -f 2 | xargs)


################################
echo "Fichier en clair"

cat 02-demo.yaml && echo

################################
echo "Chiffrement du fichier avec $pubKey en destinataire"

sops -e --age "$pubKey" 02-demo.yaml > 02-demo.secrets.yaml

################################
echo "Chiffrement partiel"

cat << EOF
username: sylvain
website: https://sylvain.dev
password: "****""
access_key: "****"
secret_key: "****""
EOF

sops -e --encrypted-suffix password --age "$pubKey" 02-partial-demo.yaml > 02-partial-demo.secrets.yaml

cat 02-partial-demo.secrets.yaml

echo "Oups, il me faudrait une regex pour identifier les clés à chiffrer !"
sops -e --encrypted-regex "(password)|(key)" --age "$pubKey" 02-partial-demo.yaml > 02-partial-demo.secrets.yaml
cat 02-partial-demo.secrets.yaml

#############################
echo "Et maintenant, pour déchiffrer mes données ?"

export SOPS_AGE_KEY_FILE=$(pwd)/age.key
sops -d 02-partial-demo.secrets.yaml

############################
echo "Et pour mettre à jour les données d'un fichier de secret existant ?"
sops 02-partial-demo.secrets.yaml

cat 02-partial-demo.secrets.yaml

##########################
echo "Mais je n'aime pas vim moi !"
EDITOR="code --wait" sops 02-partial-demo.secrets.yaml

