#!/bin/bash

set -x

if [ $# -ne 2 ]; then
  echo "Usage: install.sh <RASPBERRY_PI_IP> <RASPBERRY_PI_USERNAME>"
  exit 1
fi

RASPBERRY_PI_IP=$1
RASPBERRY_PI_USERNAME=$2

echo "Installing support packages ..."
sudo apt-get install jq
GRAFANA_VERSION=$(curl https://api.github.com/repos/grafana/grafana/releases | jq '[.[]|select(.name | contains("beta")|not)][0].tag_name' | awk '{print substr($1,3,length($1)-3)}')
GRAFANA_PACKAGE_FILE_NAME="grafana_${GRAFANA_VERSION}_armhf.deb"
ssh "${RASPBERRY_PI_USERNAME}@${RASPBERRY_PI_IP}" << EOF
  echo "Installing support packages ..."
  sudo apt-get install jq
  echo "Updating packages database ..."
  sudo apt-get update
  echo "Installing node_exporter for Raspberry Pi ..."
  sudo apt-get install -y prometheus-node-exporter
  echo "Installing Prometheus ..."
  sudo apt-get install -y prometheus
  echo "Installing Grafana ..."
  sudo apt-get install -y adduser libfontconfig1
  wget https://dl.grafana.com/oss/release/${GRAFANA_PACKAGE_FILE_NAME}
  sudo dpkg -i ${GRAFANA_PACKAGE_FILE_NAME}
  rm ${GRAFANA_PACKAGE_FILE_NAME}
EOF