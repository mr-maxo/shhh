#!/usr/bin/env bash

# check if the user is root (has superuser privileges)
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root."
    exit 1
fi

# check is system debian like
if ! command -v apt &>/dev/null; then
    echo "Error: This script works only on debian-based servers."
    exit 1
fi

# declare an associative array
product=$(echo $1 | grep -oP "^[a-z\-]+")
if [ -z "$product" ]; then
    echo "Please provide name of tool you want to install!"
    exit 1
fi 

declare -A versions
versions["consul"]="1.16.2"
versions["nomad"]="1.6.2"
versions["consul-template"]="0.33.0"
version="${2:-${versions[${product}]}}"

hc_url='https://releases.hashicorp.com'
arch='amd64'

# install requirements
update_needed=true
for package in curl unzip; do
    if dpkg -l | grep -q " $package "; then
        continue
    else
        if "$update_needed"; then
            apt update
            update_needed=false
        fi
        apt install "$package" -y
    fi
done

# install tool
curl -o /tmp/${product}.zip \
    ${hc_url}/${product}/${version}/${product}_${version}_linux_${arch}.zip
unzip -o /tmp/${product}.zip -d /usr/bin/

# create config dir
mkdir -p "/etc/${product}"
touch "/etc/$product/config.hcl"

# create data dir
if [[ $product =~ ^(nomad|consul)$ ]]; then
    mkdir "/var/lib/$product"
fi
