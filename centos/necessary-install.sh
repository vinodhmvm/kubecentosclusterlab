#!/bin/bash
yum update -y -q
yum install vim -y -q
yum install net-tools -y -q
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i -e 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
sed -i -e 's|/swapfile|#/swapfile|' /etc/fstab
swapoff -a
mkdir /root/.ssh
cp ./id_rsa.pub /root/.ssh/authorized_keys
chown -R root:root /root/.ssh/
chmod 0600 /root/.ssh/authorized_keys
chmod 0700 /root/.ssh/
