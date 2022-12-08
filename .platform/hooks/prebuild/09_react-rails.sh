#!/usr/bin/bash

set -e

# Install Node.js
echo "Installing Node.js"
/usr/bin/wget https://rpm.nodesource.com/setup_14.x
chmod 755 setup_14.x
./setup_14.x
/usr/bin/yum -y install nodejs

# Install Yarn
echo "Installing Yarn"
/usr/bin/wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
/usr/bin/yum -y install yarn

# Yarn install
YARN=$(which yarn)

$YARN

08_install_weback:
command: "sudo npm install --save-dev webpack"
09_install_babel:
command: "sudo npm install --save-dev babel-loader"
10_webpack:
command: "bundle exec rails webpacker:install"
11_asset_precompile:
command: "bin/webpack"