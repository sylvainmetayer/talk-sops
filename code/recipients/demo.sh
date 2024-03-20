#!/usr/bin/env bash

. ../demo-magic.sh -d -w

# To avoid interference with my existing key
unset SOPS_AGE_KEY_FILE
cp init.sops.yaml .sops.yaml
# Cleanup
rm alice.key bob.key secrets.dev.yaml secrets.prod.yaml
clear

########################
p "J'ai plusieurs utilisateurs qui doivent accéder aux secrets, je ne veux pas de commande à rallonge moi !"

p "Alice et Bob travaillent sur un projet avec 2 environnements, mais seul Alice doit avoir accès aux secrets de production"
echo "(Sérieusement, Alice et Bob, t'avais plus plus d'inspiration ?)"

p "cat dev.yaml"
cat dev.yaml && echo
p "On génère une clé pour Alice et une pour Bob, et on renseigne le .sops.yaml"
clear
test -f alice.key || age-keygen > alice.key 2>/dev/null
test -f bob.key || age-keygen > bob.key 2>/dev/null

aliceKey=$(grep 'key:' alice.key | cut -d ':' -f 2 | xargs)
bobKey=$(grep 'key:' bob.key | cut -d ':' -f 2 | xargs)

sed -i "s/ALICE/$aliceKey/g" .sops.yaml
sed -i "s/BOB/$bobKey/g" .sops.yaml

pe "ls *.key && cat .sops.yaml"

wait
clear
pe "sops -e dev.yaml > secrets.dev.yaml"
echo "Plus besoin de préciser les destinataires !"
pe "sops -e prod.yaml > secrets.prod.yaml"

p "Mais est-on sur que seule Alice peut déchiffrer les secrets de production ?"
clear
pe "cat secrets.prod.yaml"
p "Note: Les commentaires sont également chiffrés !"
clear
p "On récupère la clé privée de Bob, et on teste ça !"
pei "export SOPS_AGE_KEY_FILE=$(pwd)/bob.key"

pei "sops -d secrets.prod.yaml || true"

p "Et maintenant, avec la clé d'Alice"
clear
pe "export SOPS_AGE_KEY_FILE=$(pwd)/alice.key"
pei "sops -d secrets.prod.yaml || true"
