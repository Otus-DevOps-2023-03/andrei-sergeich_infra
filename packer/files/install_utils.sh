#!/bin/bash

apt install -y ruby-full ruby-bundler build-essential git
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add - # После пайпа sudo не убрано - иначе не отработает добавление ключа
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt update
sleep 5
apt install -y mongodb-org
systemctl enable --now mongod
