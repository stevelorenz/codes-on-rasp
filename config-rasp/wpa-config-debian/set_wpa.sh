#!/bin/bash

echo "Copy WPA config files..."
sudo mv ./wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
sudo mv ./interfaces /etc/network/interfaces
echo "Copy finised. Edit wpa_supplicant.conf"

sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
