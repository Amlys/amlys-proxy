#!/bin/bash

# Get the file containing the list of sites to block
sites_file="$1"

# Check if the sites file exists
if [ ! -f "$sites_file" ]; then
    echo "Error: Sites file not found."
    exit 1
fi

# Check if Squid is installed
if ! rpm -q squid &>/dev/null; then
  echo "Squid is not installed. Installing now..."
  sudo yum install squid -y
  echo Save the original config
  cp /etc/squid/squid.conf /etc/squid/squid.conf.original

  echo Editing Squid config
  # vi /etc/squid/squid.conf
  echo acl bloquesites dstdomain "/etc/squid/bloquesites.acl" >> /etc/squid/squid.conf
  echo http_access deny bloquesites >> /etc/squid/squid.conf
fi

# Copy the sites to block into the bloquesites.acl file
echo "Blocking sites..."
sudo cp "$sites_file" /etc/squid/bloquesites.acl

# Restart Squid to apply the changes
sudo systemctl restart squid

echo "The sites have been successfully added to the list of blocked sites."