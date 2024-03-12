#!/usr/bin/env bash

gnome-terminal --window-with-profile=demo --full-screen --working-directory "$(pwd)/code"
firefox -P work --new-window 'http://localhost:8000' --kiosk