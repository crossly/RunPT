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
apt-get install curl build-essential default-jdk software-properties-common python-software-properties unzip -y
add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main"

curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get install nodejs -y
apt-get update
apt-get install oracle-java8-installer -y
ln -s /usr/bin/nodejs /usr/bin/node
apt-get install npm -y
npm install pm2@latest -g

# Download 1.2.6.8 PT
wget https://github.com/taniman/profit-trailer/releases/download/v1.2.6.11/ProfitTrailer.zip
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

# Set Billy's Strategy
while :; do echo
  read -p "Are you want to deploy default BTC market strategy? [y/n]: " deploy_strategy
  if [[ ! $deploy_strategy =~ ^[y,n]$ ]]; then
    echo "${CWARNING}input error! Please only input 'y' or 'n'${CEND}"
  else
    break
  fi
done

trading_dca="/root/ProfitTrailer/trading/DCA.properties"
trading_pairs="/root/ProfitTrailer/trading/PAIRS.properties"
trading_indicators="/root/ProfitTrailer/trading/INDICATORS.properties"
if [ $deploy_strategy == 'y' ]; then
cat > $trading_dca <<EOF
#######################################################
#######################################################
### 平均成本法策略设置: DCA.properties              ###
### 官方网站      - http://profittrailer.cn         ###
### 中文维基百科  - http://wiki.profittrailer.io    ###
### 电报群组      - http://t.me/profittrailer       ###
### QQ群组        - 426927032                       ###
### 百度下载点    - http://pan.baidu.com/s/1nuFHT0X ###
### 电邮          - info@profittrailer.cn           ###
#######################################################
#######################################################

enabled = true

#基本设定 (General Settings)
max_cost = 0
max_buy_times = 3
max_buy_spread = 2
min_buy_balance = 0
#min_buy_balance_percentage = 20
#min_buy_volume = 100
buy_available_volume_trigger = 125


#买入策略设定 (Buy Strategy Settings)
#buy_strategy = LOWBB
#buy_value = 0
#buy_trigger = -5
#trailing_buy = 0.1


buy_strategy = ANDERSON
buy_style = DOUBLEDOWN
buy_trigger_1 = -14.5
buy_trigger_2 = -24.5
buy_trigger_3 = -34.5
buy_trigger_4 = -49.5
trailing_buy = 0.17


#卖出策略设定 (Sell Strategy Settings)
sell_strategy = GAIN
sell_value = 1
sell_trigger = 1
trailing_profit = 0.3
stop_loss_trigger = 0
pending_order_wait_time = 0
ignore_sell_only_mode = true
EOF
cat > $trading_pairs <<EOF
#######################################################
#######################################################
### 买卖交易设置：PAIRS.properties                  ###
### 官方网站      - http://profittrailer.cn         ###
### 中文维基百科  - http://wiki.profittrailer.io    ###
### 电报群组      - http://t.me/profittrailer       ###
### QQ群组        - 426927032                       ###
### 百度下载点    - http://pan.baidu.com/s/1nuFHT0X ###
### 电邮          - info@profittrailer.cn           ###
#######################################################
#######################################################
BNBBTC_trading_enabled = false
#######################################################

#基本设定 (General Settings)
MARKET = BTC
ALL_trading_enabled = true
ALL_enabled_pairs = ALL
#ALL_enabled_pairs = ADABTC,BCCBTC,DASHBTC,ELFBTC,EOSBTC,ETCBTC,ETHBTC,HSRBTC,ICXBTC,IOTABTC,LSKBTC,LTCBTC,NEOBTC,OMGBTC,POWRBTC,QTUMBTC,SNTBTC,TRXBTC,VENBTC,VIBBTC,XLMBTC,XMRBTC,XRPBTC,XVGBTC,ZECBTC
#ALL_enabled_pairs = QTUMBTC,ADABTC,IOTABTC,BRDBTC,SNGLSBTC,ARNBTC,DLTBTC,NULSBTC,RCNBTC,ENGBTC,BNBBTC,SUBBTC,GVTBTC,KNCBTC,VIBBTC,ADXBTC,ICXBTC,MCOBTC,SNMBTC,BATBTC,MODBTC,WABIBTC,FUNBTC,BCPTBTC,DGDBTC,FUELBTC,MDABTC,GASBTC,OMGBTC,LINKBTC,XZCBTC,OAXBTC,YOYOBTC,EVXBTC,STRATBTC,SALTBTC,ETHBTC,MTHBTC,ZRXBTC,BTSBTC,PPTBTC,NEOBTC,BNTBTC,GTOBTC,DNTBTC,TNTBTC,QSPBTC,ZECBTC,RDNBTC,ETCBTC,CDTBTC,ICNBTC,LSKBTC,BTGBTC,MTLBTC,TNBBTC,LTCBTC,XVGBTC,STORJBTC,DASHBTC,REQBTC,AMBBTC,GXSBTC,CMTBTC,BCCBTC,MANABTC,EOSBTC,LRCBTC,BQXBTC,XMRBTC,HSRBTC,POWRBTC,AIONBTC,ASTBTC,LENDBTC,OSTBTC,POEBTC,ARKBTC,VENBTC,XRPBTC,SNTBTC,


#可能买入选单设定 (Possible Buy Settings)
ALL_min_buy_volume = 700
ALL_min_buy_price = 0
ALL_max_buy_spread = 1
ALL_max_trading_pairs = 8
ALL_min_buy_balance = 0
ALL_min_buy_balance_percentage = 0
ALL_buy_available_volume_trigger = 110


#买入策略设定 (Buy Strategy Settings)
#ALL_max_cost_percentage = 2
ALL_max_cost = 0.0025
ALL_max_cost_percentage = 0
ALL_buy_strategy = EMAGAIN
#ALL_buy_strategy = LOWBB
ALL_buy_value = -0.55
ALL_buy_value_limit = 0
ALL_trailing_buy = 0.1


#卖出策略设定 (Sell Strategy Settings)
ALL_sell_strategy = GAIN
ALL_sell_value = 0.75
ALL_min_profit = 0.75
ALL_trailing_profit = 0.1


#危机抛售策略 （Dump Strategy Settings)
ALL_panic_sell_enabled = false
All_stop_loss_trigger = 0
ALL_stop_loss_timeout = 0
ALL_sell_only_mode = false


#基本保护机制 (General Protection Mechanism)
#ALL_DCA_enabled = -5
#ALL_DCA_enabled = -4.5
ALL_DCA_enabled = -9.5

ALL_btc_price_drop_trigger = 0
ALL_btc_price_drop_recover_trigger = 0

ALL_btc_price_rise_trigger = 0
ALL_btc_price_rise_recover_trigger = 0

ALL_consecutive_buy_trigger = 0
ALL_consecutive_sell_trigger = 0

ALL_pending_order_wait_time = 0
ALL_combined_cancel_pending_trigger = 0
EOF
cat > $trading_indicators <<EOF
#######################################################
#######################################################
### 布林带/保力加通道策略: INDICATORS.properties    ###
### 官方网站      - http://profittrailer.cn         ###
### 中文维基百科  - http://wiki.profittrailer.io    ###
### 电报群组      - http://t.me/profittrailer       ###
### QQ群组        - 426927032                       ###
### 百度下载点    - http://pan.baidu.com/s/1nuFHT0X ###
### 电邮          - info@profittrailer.cn           ###
#######################################################
#######################################################



#定义机器人所有 BB 计算所使用的时间区间周期（以秒为单位）。
BB_period = 300

#定义 SMA 时间框架（阴阳烛）给机器人计算 BB SMA 线。
BB_sma = 40



#定义(以秒为单位)的周期给机器人计算 SMA 线。
SMA_period = 300

#定义 SMA 时间框架（阴阳烛）给机器人计算 SMA 慢线。
SMA_1 = 24

#定义 SMA 时间框架（阴阳烛）给机器人计算 SMA 快线。
SMA_2 = 12

#当两条 SMA 快慢线相交之后，设置对多少支阴阳烛去给 SMACROSS 策略作买入决定。
#SMA_cross_candles = 2



#定义(以秒为单位)的周期给机器人计算 EMA 线。
EMA_period = 300

#定义 EMA 时间框架（阴阳烛）给机器人计算慢 EMA 慢线。
EMA_1 = 36

#定义 EMA 时间框架（阴阳烛）给机器人计算快 EMA 快线。
EMA_2 = 9

#当两条 EMA 快慢线相交之后，设置对多少支阴阳烛去给 EMACROSS 策略作买入决定。
#EMA_cross_candles = 2
EOF

fi

# Print java version
javac -version
printf "# Installation Completed Successfully.\n"
# Clean files
rm -rf nodesource_setup.sh ProfitTrailer.zip runpt.sh