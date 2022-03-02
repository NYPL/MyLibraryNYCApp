#!/usr/bin/bash

set -e

# Install Node.js
echo "Installing Node.js"
wget https://rpm.nodesource.com/setup_14.x
chmod 755 setup_14.x
./setup_14.x
/usr/bin/yum -y install nodejs

# Install Yarn
echo "Installing Yarn"
wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
/usr/bin/yum -y install yarn

# Yarn install
YARN=$(which yarn)

$YARN