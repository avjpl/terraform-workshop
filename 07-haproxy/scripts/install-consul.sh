#!/bin/bash
set -e

echo "Installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y unzip

echo "Fetching Consul..."
cd /tmp
curl -L -o consul.zip https://releases.hashicorp.com/consul/0.5.2/consul_0.5.2_linux_amd64.zip

echo "Installing Consul..."
unzip consul.zip >/dev/null
sudo chmod +x consul
sudo mv consul /usr/local/bin/consul
sudo mkdir -p /etc/consul.d
sudo mkdir -p /mnt/consul
sudo mkdir -p /etc/service

if [ -f /tmp/web.json ]; then
  sudo mv /tmp/web.json /etc/consul.d/web.json
fi

echo "Installing Upstart service..."
sudo mv /tmp/consul.conf /etc/init/consul.conf

echo "Starting Consul..."
sudo start consul
