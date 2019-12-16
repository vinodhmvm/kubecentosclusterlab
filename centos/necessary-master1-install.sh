#!/bin/bash
cp ./id_rsa* /root/.ssh/
chown -R root:root /root/.ssh/
chmod 0600 /root/.ssh/id_rsa*
chmod 0700 /root/.ssh/
