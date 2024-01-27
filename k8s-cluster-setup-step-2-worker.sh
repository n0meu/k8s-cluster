#!/bin/bash

# WORKER - firewall 
sudo ufw allow 10250/tcp
sudo ufw allow 30000:32767/tcp
sudo ufw reload

./k8s-cluster-partial-containerd.sh

./k8s-cluster-partial-kubelet-kubeadm-kubectl.sh

echo ""
echo "!!! now use the join command"
echo "like this: sudo kubeadm join k8s-ctl-f67d5:6443 --token nm2187.lqilx1f0gid4jiau \
--discovery-token-ca-cert-hash sha256:92678724c4828b503f5c5f991f2a25272f14e68a24b76f04b44d769155578009"
echo ""
echo "repeat this (this script and join) on all other worker nodes"
echo "after that next step k8s-cluster-setup-step-3-calico.sh on CONTROLLER node"
echo ""