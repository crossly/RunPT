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
apt-get install curl build-essential default-jdk software-properties-common unzip -y
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

# Set VM Ram Usage
while :; do echo
  read -p "Are you using Alpharacks' 768RAM VPS ? [y/n]: " alpha_ram
  if [[ ! $alpha_ram =~ ^[y,n]$ ]]; then
    echo "${CWARNING}input error! Please only input 'y' or 'n'${CEND}"
  else
    break
  fi
done

if [ $alpha_ram == 'y' ]; then
  ram_usage=400
else
  ram_usage=512
fi
pm2_config_file="/root/ProfitTrailer/pm2-ProfitTrailer.json"

cat > $pm2_config_file <<EOF
{
  "apps": [
    {
      "name": "profit-trailer",
      "cwd": ".",
      "script": "java",
      "args": [
        "-XX:+UseConcMarkSweepGC",
        "-Xmx${ram_usage}m",
        "-Xms${ram_usage}m",
        "-jar",
        "ProfitTrailer.jar"
      ],
      "env": {
        "SPRING_PROFILES_ACTIVE": "prod"
      },
      "node_args": [],
      "log_date_format": "YYYY-MM-DD HH:mm Z",
      "exec_interpreter": "",
      "exec_mode": "fork",
      "autorestart": false
    }
  ]
}
EOF

# Print java version
javac -version
# Clean files
rm -rf nodesource_setup.sh ProfitTrailer.zip runpt.sh