#!/usr/bin/env bash

product='consul-template'
version='0.33.0'
hc_url='https://releases.hashicorp.com'
arch='amd64'

curl -o /tmp/${product}.zip \
    ${hc_url}/${product}/${version}/${product}_${version}_linux_${arch}.zip
unzip /tmp/${product}.zip -d /usr/bin/
