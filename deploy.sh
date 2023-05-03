#!/bin/bash

sudo apt install -y git

cd ~
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d

puma_PID=$(ps aux | grep [p]uma | awk '{print $2}')
echo "Application started at port: $(sudo netstat -tunlp | grep $puma_PID | awk '{print $4}' | awk -F ":" '{print $2}')"
