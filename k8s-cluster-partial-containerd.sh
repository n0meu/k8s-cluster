#!/bin/bash

# ALL -Install Containerd Run time on All Nodes
# - prepare containerd
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf 
overlay 
br_netfilter
EOF
sudo modprobe overlay 
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1 
net.bridge.bridge-nf-call-ip6tables = 1 
EOF

sudo sysctl --system

# - install containerd
sudo apt update
sudo apt -y install containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1

# in /etc/containerd/config.toml (currently in line 125) look for the section [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options] and change "SystemdCgroup = false" to "SystemdCgroup = true"
sed -i '/SystemdCgroup = false/ s/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sed -i '/sandbox_image = "registry\.k8s\.io\/pause:3\.6"/ s/sandbox_image = "registry\.k8s\.io\/pause:3\.6"/sandbox_image = "registry.k8s.io\/pause:3.9"/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd
