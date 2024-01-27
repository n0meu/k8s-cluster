#!/bin/bash

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/release-v3.27/manifests/calico.yaml

sudo ufw allow 179/tcp
sudo ufw allow 4789/udp
sudo ufw allow 51820/udp
sudo ufw allow 51821/udp
sudo ufw reload
