#!/bin/bash
echo "------>> Install vim" &&
echo "------>> Install git" &&
echo "------>> Install zsh" &&\
apt install zsh &&\
echo "------>> Installing oh-my-zsh" &&\
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &&\
echo "----> restart after chsh -s $(which zsh)" &&\
echo "----> Install build essentials"
echo "------>> Install postgres build tools; apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev"   &&\
apt-get install postgresql-11 postgresql-contrib libpq-dev
echo "------>>Optional only install postgresql client by;; sudo apt install postgresql-client-11"&&\
echo "------>> Install docker" &&\
apt-get remove docker docker-engine docker.io && \
apt install docker.io -y && \
echo "------>> Install docker compose" &&
echo "------>> Install docker postgres 11" &&\
docker pull postgres:11.4 &&\
echo "------>> Install docker elasticsearch 2.3" &&\
sudo docker pull docker.elastic.co/elasticsearch/elasticsearch:7.2.0 &&
sudo docker pull elasticsearch:2.3.3 &&
echo "------>> Install slack" &&\
echo "------>> Install vscode" &&\
echo "------>> Install postman" &&\
echo "------>> Install steam" &&\
echo "------>> Install Chrome" &&\
echo "------>> Install fuzzy search" &&\
echo "------>> Install go" &&\
echo "------>> Install redis" &&\
echo "------>> Install nodejs" &&\
echo "------>> Install nvm" &&\
echo "------>> Install nvim" &&\
apt install neovim &&\
echo "chruby" && \
echo "------>> Install rvm ruby-2.3.0" &&\
echo "------>> Install rvm ruby-2.3.1" &&\
echo "------>> Install rvm ruby-latest" &&\
echo "------>> Install elixir"
echo "------>> Install vim plug"
echo "Install nerd fonts"
echo "Install npm, gulp, yarn"
echo "sudo apt-get install inotify-tools"
echo "sudo apt-get install libpq-dev "
echo "Install htop"
