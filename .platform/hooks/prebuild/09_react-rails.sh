#!/usr/bin/bash

set -e

# Install Node.js
echo "Installing Node.js"
/usr/bin/yum-config-manager --enable epel
/usr/bin/yum -y install nodejs

# Install Yarn
echo "Installing Yarn"
/user/bin/wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
/usr/bin/yum -y install yarn

# Yarn install
YARN=$(which yarn)

$YARN