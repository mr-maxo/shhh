#!/usr/bin/env bash

product='consul'
version='1.16.2'
hc_url='https://releases.hashicorp.com'
arch='amd64'

apt update
apt install -y curl unzip

curl -o /tmp/${product}.zip \
    ${hc_url}/${product}/${version}/${product}_${version}_linux_${arch}.zip
unzip /tmp/${product}.zip -d /usr/bin/

mkdir -p /etc/${product}
touch /etc/consul/config.hcl
