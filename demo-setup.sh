#!/usr/bin/env bash

gnome-terminal --window-with-profile=demo --full-screen --working-directory "$(pwd)/code"
firefox -P work --new-window 'http://localhost:8000'

echo "Silent mode is on?"

echo "Battery saver"
sudo systemctl stop docker.service
sudo systemctl stop cbagentd.service
sudo systemctl stop forticlient.service


kubectx -u || true