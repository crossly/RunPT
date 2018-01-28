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
# Download newest PT
wget https://github.com/taniman/profit-trailer/releases/download/v1.2.6.12/ProfitTrailer.zip
unzip ProfitTrailer.zip -d /tmp/
mv /tmp/ProfitTrailer/ProfitTrailer.jar /root/ProfitTrailer/ProfitTrailer.jar
rm -rf /tmp/ProfitTrailer updatept.sh ProfitTrailer.zip

printf "Done!\n"