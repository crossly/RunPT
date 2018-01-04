#!/bin/bash
# Author:  Xlemon
# Contact me: Telegram @xlemons
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
clear
printf "
#############################################################################################
#     PT Runtime environment setup for Alpharacks Debian 7&8 Mayby Support Ubunt 14-16      #
#                 For more information please concact me via Telegram                       #
#############################################################################################
"
# Check if user is root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }
#update system
apt-get update
apt-get install curl build-essential default-jdk software-properties-common -y
curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get install nodejs
apt-get update
apt-get install oracle-java8-installer
ln -s /usr/bin/nodejs /usr/bin/node
apt-get install npm
npm install pm2@latest -g

# Download 1.2.6.8 PT
wget https://github.com/taniman/profit-trailer/releases/download/v1.2.6.8/ProfitTrailer.zip
unzip ProfitTrailer.zip

javac -version
#clean files
rm -rf nodesource_setup.sh ProfitTrailer.zip runpt.sh