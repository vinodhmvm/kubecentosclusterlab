#!/bin/bash
yum -y -q install haproxy
mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.bkup
cat <<EOF > /etc/haproxy/haproxy.cfg
global
  log 127.0.0.1 local2 info
  chroot /var/lib/haproxy
  stats socket /var/run/admin.sock mode 660 level admin
  stats timeout 30s
  user haproxy
  group haproxy
  daemon

defaults
  mode http
  log global
  timeout connect 30s
  timeout client 1m
  timeout server 1m
  timeout check 10s

frontend k8s-api
  bind 192.168.5.30:443
  mode tcp
  default_backend kube-bac

backend kube-bac
  mode tcp
  option tcp-check
  balance roundrobin
  server master-1 192.168.5.11:6443 check
  server master-2 192.168.5.12:6443 check
  server master-3 192.168.5.13:6446 check
EOF

systemctl start haproxy
systemctl enable haproxy
