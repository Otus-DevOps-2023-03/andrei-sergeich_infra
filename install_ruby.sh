#!/bin/bash

sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
echo `ruby -v` && echo `bundler -v`
