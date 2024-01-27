#!/bin/bash

CONTROLLER=$(hostname -f)

# CONTROLLER - firewall 
    # Kubernetes API server
    sudo ufw allow 6443/tcp
    # etcd
    sudo ufw allow 2379:2380/tcp
    # Kubelet API
    sudo ufw allow 10250/tcp

    sudo ufw allow 10251/tcp
    sudo ufw allow 10252/tcp
    sudo ufw allow 10255/tcp
    sudo ufw reload

./k8s-cluster-partial-containerd.sh

./k8s-cluster-partial-kubelet-kubeadm-kubectl.sh

# CONTROLLER - Install Kubernetes Cluster with Kubeadm
cat <<EOF > ./kubelet-controller.yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: "1.28.0"
controlPlaneEndpoint: "$CONTROLLER"
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
EOF

sudo kubeadm init --config kubelet-controller.yaml

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo ""
echo "!!! now YOU memorize both join token commands (controll-plane and worker) .."
echo ""
echo "next step k8s-cluster-setup-step-2-worker.sh on each worker node"
