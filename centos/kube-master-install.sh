#!/bin/bash
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

yum install -y -q kubelet-1.13.12-0.x86_64 kubeadm-1.13.12-0.x86_64 kubectl-1.13.12-0.x86_64 --disableexcludes=kubernetes

systemctl enable --now kubelet
kubeadm config images pull
