#!/usr/bin/env bash

. ./demo-magic.sh -d -w

# To avoid interference with my existing key
unset SOPS_AGE_KEY_FILE
clear

################################
p " Création d'une clé age"
p "age-keygen > age.key"
test -f age.key || age-keygen > age.key 2>/dev/null
cat age.key

pubKey=$(grep 'key:' age.key | cut -d ':' -f 2 | xargs)

wait
################################
clear
p " Partons d'un fichier en clair"
pei "cat 02-demo.yaml" && echo

################################
p " Chiffrement du fichier avec $pubKey en destinataire"

pei "sops -e --age \"$pubKey\" 02-demo.yaml > 02-demo.secrets.yaml"

################################
p " Un autre fichier, avec seulement une donnée à chiffrer..."

p "cat 02-partial-demo.yaml"
cat 02-partial-demo-fake.yaml && echo
pe "sops -e --encrypted-suffix password --age \"$pubKey\" 02-partial-demo.yaml > 02-partial-demo.secrets.yaml"
pei "cat 02-partial-demo.secrets.yaml"

p " Oups, il me faudrait une regex pour identifier les clés à chiffrer !"
pe "sops -e --encrypted-regex \"(password)|(key)\" --age \"$pubKey\" 02-partial-demo.yaml > 02-partial-demo.secrets.yaml"
pei "cat 02-partial-demo.secrets.yaml"

p " Et maintenant, pour déchiffrer mes données ?"
pe "sops -d 02-partial-demo.secrets.yaml"
p " Oups, j'ai oublié de préciser ma clé privée"
pei "export SOPS_AGE_KEY_FILE=$(pwd)/age.key"
pe "sops -d 02-partial-demo.secrets.yaml"

p " Et pour mettre à jour les données d'un fichier de secret existant ?"
pe sops 02-partial-demo.secrets.yaml
pei "cat 02-partial-demo.secrets.yaml"

p "Mais je n'aime pas vim moi !"
pe "EDITOR=\"code --wait\" sops 02-partial-demo.secrets.yaml"
pei "cat 02-partial-demo.secrets.yaml"
