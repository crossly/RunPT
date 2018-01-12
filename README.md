# 跑PT推荐以下VPS
KVM:
- RAM：512M 一年 18$ https://www.alpharacks.com/myrack/aff.php?aff=1045&pid=58
- RAM：1024M 一年 28$ https://www.alpharacks.com/myrack/aff.php?aff=1045&pid=148

OpenVZ:
- RAM：768M 一年 9.9$ https://www.alpharacks.com/myrack/aff.php?aff=1045&pid=224 `推荐一个 BOT 买一个这个，挂多个 BOT，买多个。IP 保持唯一。注意内存吃紧，这台机器跑一个目前的版本没有问题的。`
- RAM：2048M 一年 19.9$ https://www.alpharacks.com/myrack/aff.php?aff=1045&pid=225 `长远考虑，推荐购买2GB内存的机型，一个机器开一个BOT，宽容度更高。`
- RAM：3072M 一年 25$ https://www.alpharacks.com/myrack/aff.php?aff=1045&pid=227

# ProfitTrailer 运行环境一键安装
本脚本会辅助你安装运行PT所需要的Java8，以及PM2。
额外做的一件事情是，帮你下载了1.2.6.8的PT，并解压到了/root/ProfitTrailer目录下。

本脚本支持上面推荐的Alpharacks家的Ubuntu 14-16，Debian 7&8 系统，别家的别的系统可能不支持。

# 环境安装方法：
```bash
wget -N --no-check-certificate https://github.com/lemonsx/runpt/raw/master/runpt.sh && bash runpt.sh
```

# 特别说明
运行完这个脚本后，你需要自行通过Winscp修改替换你自己的配置文件和策略文件。
好吧，我还是给你们写了，看这里：https://medium.com/@xlemon/%E5%9C%A8vps%E4%B8%8A%E5%BF%AB%E9%80%9F%E9%83%A8%E7%BD%B2%E4%BD%A0%E7%9A%84profittrailer%E6%9C%BA%E5%99%A8%E4%BA%BA-4f7fe6e5b987

还有，PT使用过程中有问题的话不要找我啊。
请加入Telegram中文群组 https://t.me/ProfitTrailer

# 更新日志
## 2018/01/09
- 可选部署Billy的PT策略