#!/usr/bin/env bash

echo "Silent mode is on?"
echo "T'as coupé le son ?"
echo "T'as tout fermé ?"
read -r

echo "Battery saver"
#sudo systemctl stop docker.service
#sudo systemctl stop cbagentd.service
#sudo systemctl stop forticlient.service

kubectx -u || true

gnome-terminal --window-with-profile=demo --full-screen --working-directory "$(pwd)/code/recipients"
# Update with current demo
firefox -P work 'https://sops.talks.sylvain.dev/' 'http://localhost:8000'
systemctl restart --user xremap
