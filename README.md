# 跑PT推荐以下VPS
KVM:
- RAM：512M 一年 18$ https://www.alpharacks.com/myrack/aff.php?aff=1045&pid=58
- RAM：1024M 一年 28$ https://www.alpharacks.com/myrack/aff.php?aff=1045&pid=148

OpenVZ:
- RAM：768M 一年 9.9$ https://www.alpharacks.com/myrack/aff.php?aff=1045&pid=224 `推荐一个 BOT 买一个这个，挂多个 BOT，买多个。IP 保持唯一。`
- RAM：2048M 一年 19.9$ https://www.alpharacks.com/myrack/aff.php?aff=1045&pid=225
- RAM：3072M 一年 25$ https://www.alpharacks.com/myrack/aff.php?aff=1045&pid=227

# ProfitTrailer 运行环境一键安装
本脚本会辅助你安装运行PT所需要的Java8，以及PM2。
额外做的一件事情是，帮你下载了1.2.6.8的PT，并解压到了/root/ProfitTrailer目录下。


# 环境安装方法：
  wget -N --no-check-certificate https://github.com/lemonsx/runpt/raw/master/runpt.sh && bash runpt.sh

# 特别说明
运行完这个脚本后，你需要自行通过Winscp修改替换你自己的配置文件和策略文件。

还有，PT使用过程中有问题的话不要找我啊。