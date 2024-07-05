#!/usr/bin/env bash

. ../demo-magic.sh -d -w

# To avoid interference with my existing key
unset SOPS_AGE_KEY_FILE
# Cleanup
cp init/.sops.yaml .sops.yaml
rm alice.key bob.key secrets.dev.yaml secrets.prod.yaml
rm -rf envs/*.yaml
cp init/* envs/
clear

########################
p "Alice et Bob travaillent sur un projet avec 2 environnements, mais seule Alice doit avoir accès aux secrets de production"
echo "(Sérieusement, Alice et Bob, t'avais plus plus d'inspiration ?)"

p "cat envs/secrets.dev.yaml"
bat --theme Coldark-Cold envs/secrets.dev.yaml
wait
clear
p "On génère une clé pour Alice et une pour Bob, et on renseigne le .sops.yaml"
test -f alice.key || age-keygen > alice.key 2>/dev/null
test -f bob.key || age-keygen > bob.key 2>/dev/null

aliceKey=$(grep 'key:' alice.key | cut -d ':' -f 2 | xargs)
bobKey=$(grep 'key:' bob.key | cut -d ':' -f 2 | xargs)

sed -i "s/ALICE/$aliceKey/g" .sops.yaml
sed -i "s/BOB/$bobKey/g" .sops.yaml

p "cat .sops.yaml"
bat --theme Coldark-Cold .sops.yaml

wait
clear
pe "sops -i -e envs/secrets.dev.yaml"
echo "Plus besoin de préciser les destinataires !"
pe "sops -i -e envs/secrets.prod.yaml"
clear

p "Mais est-on sur que seule Alice peut déchiffrer les secrets de production ?"

p "cat envs/secrets.prod.yaml"
bat -r 1:4 -r 9:18 --theme Coldark-Cold envs/secrets.prod.yaml

echo "Note: Les commentaires sont également chiffrés !"
wait
clear

p "On récupère la clé privée de Bob, et on teste ça !"
pei "export SOPS_AGE_KEY_FILE=$(pwd)/bob.key"

pei "sops -d envs/secrets.prod.yaml || true"
p ""
clear
p "Et maintenant, avec la clé d'Alice"
pe "export SOPS_AGE_KEY_FILE=$(pwd)/alice.key"
pei "sops -d envs/secrets.prod.yaml"

wait