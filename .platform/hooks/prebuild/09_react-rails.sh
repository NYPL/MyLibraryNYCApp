#!/usr/bin/env bash
set -e

# Install Node.js
echo "Installing Node.js"
yum-config-manager --enable epel
yum -y install nodejs

# Install Yarn
echo "Installing Yarn"
wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo;
yum -y install yarn;

# Yarn install
yarn