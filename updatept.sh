#!/bin/bash
# Author:  Xlemon
# Contact me: Telegram @xlemons
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
clear
printf "
#############################################################################################
#                     Update ProfitTrailer to new version for RunPT                         #
#############################################################################################
"
apt-get install curl zip -y
# Download newest PT
wget https://raw.githubusercontent.com/lemonsX/RunPT/master/ProfitTrailer-11.zip
unzip ProfitTrailer.zip -d /tmp/
# Start to mod PT
unzip /tmp/ProfitTrailer/ProfitTrailer.jar -d /tmp/ProfitTrailer/unzip
# add js load script
sed '644i    \<script src=\"js/ProfitTrailer_GUI_extensions_v1.1.user.js\"></script>' -i /tmp/ProfitTrailer/unzip/BOOT-INF/classes/templates/index.ftl

pt_plugin_file="/tmp/ProfitTrailer/unzip/BOOT-INF/classes/static/js/ProfitTrailer_GUI_extensions_v1.1.user.js"

curl -o /tmp/ProfitTrailer/unzip/BOOT-INF/classes/static/js/ProfitTrailer_GUI_extensions_v1.1.user.js https://raw.githubusercontent.com/lemonsX/RunPT/master/ProfitTrailer_GUI_extensions_v1.1.user.js
# Change Folder
cd /tmp/ProfitTrailer/unzip
# pack jar
zip -r -0 ../ProfitTrailer.jar ./*
mv /tmp/ProfitTrailer/ProfitTrailer.jar /root/ProfitTrailer/ProfitTrailer.jar
cd ~
rm -rf /tmp/ProfitTrailer updatept.sh ProfitTrailer.zip


printf "Done!\n"