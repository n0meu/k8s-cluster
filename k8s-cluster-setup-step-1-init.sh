#!/bin/bash

# short description
# - install sudo curl gpg 
# - diable swap
# - add given users to sudos without password

# ALL - define names and add all node in all /etc/hosts
#   example:
#
#   sudo hostnamectl set-hostname "k8s-ctl-f67d5.local"
#
#   172.16.0.11 k8s-ctl-f675d5.local k8s-ctl-f67d5
#
#   172.16.0.21 k8s-wrk-8e6e7e.local k8s-wrk-8e6e7e
#   172.16.0.22 k8s-wrk-e7e53a.local k8s-wrk-e7e53a

if [[ "$(whoami)" != 'root' ]]
then
    echo "You musst are running this script as root user!"
else
    # ALL - install sudo curl gpg
    apt update && apt upgrade -y
    apt install -y sudo curl gpg ufw git

    ufw allow 22/tcp

    # ALL - disable swap
    swapoff -a
    sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

    # ALL - 
    if [[ "$@" = '' ]]
    then
        echo "missig new sudo users (optional)"
        echo "example: $0 foo bar"
    else
        for USER in "$@"
        do
            /sbin/usermod -aG sudo $USER
            echo "$USER  ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/$USER.k8s.setup
        done
    fi
fi