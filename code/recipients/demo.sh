#!/usr/bin/env bash

cp init.sops.yaml .sops.yaml
########################
echo "C'est bien long tout ça comme commande, t'as pas mieux ? J'ai plusieurs utilisateurs qui doivent accéder aux secrets, et pas à tous en plus !"

echo "Alice et bob travaillent sur un projet avec 2 environnements, mais seul Alice doit avoir accès aux secrets de production"

ls dev.yaml prod.yaml

cat dev.yaml

echo "(Sérieusement, alice et bob, t'avais plus plus d'inspiration ?)"

echo "On génère une clé pour Alice et une pour Bob"

# TODO

aliceKey=$(grep 'key:' alice.key | cut -d ':' -f 2 | xargs)
bobKey=$(grep 'key:' bob.key | cut -d ':' -f 2 | xargs)

sed -i "s/ALICE/$aliceKey/g" .sops.yaml
sed -i "s/BOB/$bobKey/g" .sops.yaml

sops -e dev.yaml > secrets.dev.yaml
sops -e prod.yaml > secrets.prod.yaml
echo "C'est plus court comme ça non ?"

echo "Mais est-on sur que seul Alice peut déchiffrer les secrets de production ?"

cat secrets.prod.yaml

echo "Note: Les commentaires sont également chiffrés !"

echo "On récupère la clé privée de Bob, et on teste ça !"
export SOPS_AGE_KEY_FILE=$(pwd)/bob.key

sops -d secrets.prod.yaml || true

echo "Et maintenant, avec la clé d'Alice"
export SOPS_AGE_KEY_FILE=$(pwd)/alice.key
sops -d secrets.prod.yaml || true

